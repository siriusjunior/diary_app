class Mypage::CreditcardsController < Mypage::BaseController
  before_action :set_api
  def new
    redirect_to edit_mypage_creditcard_path if current_user.customer_id.present?
  end

  def create
    current_user.register_creditcard!(token: params['payjp-token'])
    redirect_to edit_mypage_creditcard_path, info: 'クレジットカードを登録しました'
  rescue Payjp::PayjpError => e
    redirect_to new_mypage_creditcard_path, danger: e.message
  end

  def edit
    @card = current_user.default_card
  rescue Payjp::PayjpError => e
    redirect_to root_path, danger: e.message
  end

  def update
    current_user.change_default_card!(token: params['payjp-token'])
    redirect_to edit_mypage_creditcard_path, info: 'クレジットカードを登録しました'
  rescue Payjp::PayjpError => e
    redirect_to edit_mypage_creditcard_path, danger: e.message
  end

  private

    def set_api
      Payjp.api_key = Settings.payjp.dig(:sk)
    end
end
