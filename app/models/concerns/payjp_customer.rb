module PayjpCustomer
    extend ActiveSupport::Concern
    included do
        has_many :contracts, dependent: :restrict_with_error
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

    def subscript!(plan)
        contract = contracts.create(plan: plan)
        pay!
    end

    def pay!
        charge = charge!(latest_contract.plan.price)
        # 支払い履歴を契約に登録
        latest_contract.pay!(charge)
    end

    def latest_contract
        contracts.last
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