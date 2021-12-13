module PayjpCustomer
    extend ActiveSupport::Concern
    included do
        has_many :contracts, dependent: :restrict_with_error
        scope :subscription_to_be_updated, lambda {
            joins(contracts: :payments).joins('LEFT OUTER JOIN contract_cancellations ON contracts.id = contract_cancellations.contract_id')
                                    .where(contracts: { id: Contract.group(:user_id).select('max(id)') })#Userごとの最新contract
                                    .where(contract_cancellations: { id: nil })
                                    .where(payments: { id: Payment.groud(:contract_id).select('max(id)') })#Contractごとの最新payment
                                    .where('payments.current_period_end < ?', Time.current)
        }
    end

    def register_creditcard!(token:)
        customer = add_customer!(token: token)
        # Payjp::Customerインスタンスのid=トークン
        self.skip_password = true
        update!(customer_id: customer.id)
    end
    
    def default_card
        @default_card ||= customer.cards.retrieve(customer.default_card)
    end

    def change_default_card!(token:)
        old_card = default_card
        customer.cards.create(
            card: token,
            default: true
        )
        old_card.delete
    end

    # プラン契約して支払う
    def subscript!(plan)
        contract = contracts.create(plan: plan)
        pay!
    end

    def pay!
        charge = charge!(latest_contract.plan.price)
        # 支払い履歴を契約に登録
        latest_contract.pay!(charge)
    end

    # 解約する
    def stop_subscript!(reason: :by_user_canceled)
        latest_contract.cancel!(reason: reason)
    end

    def subscripting_to?(plan)
        subscripting? && 
        latest_contract.plan.code == plan.code
    end

    # プランを問わず契約中か
    def subscripting?
        latest_contract.present? &&
        # 最終支払いが有効期間内か
        latest_contract.payments.last.current_period_end >= Time.current.to_date
    end

    # ベーシックプランを契約中か
    def subscripting_basic_plan?
        subscripting_to?(Plan.find_by!(code: '0001'))
    end
    
    # プレミアムプランを契約中か
    def subscripting_premium_plan?
        subscripting_to?(Plan.find_by!(code: '0002'))
    end

    # 契約中でキャンセルしているか
    def about_to_cancel?(plan)
        subscripting_to?(plan) &&
        latest_contract.contract_cancellation.present?
    end

    def latest_contract
        contracts.last
    end

    # メッセージ制限チェック
    def can_message?
        # プレミアム無制限,ベーシック20件,無契約10件まで
        subscripting_premium_plan? ||
        subscripting_basic_plan? && messages.where(created_at: latest_contract.current_period_start...latest_contract.current_period_end).count <= 20 ||
        messages.count <= 10
    end

    private
    
        def add_customer!(token:)
            Payjp::Customer.create(card: token, email: email, metadata: { name: username })
        end

        def customer
            @customer ||= Payjp::Customer.retrieve(customer_id)
        end

        def charge!(price)
            Payjp::Charge.create(currency: 'jpy',
                                    amount: price,
                                    customer: customer_id)
        end
end