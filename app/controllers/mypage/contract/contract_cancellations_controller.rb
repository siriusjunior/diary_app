class Mypage::Contract::ContractCancellationsController < Mypage::BaseController
    def create
        cancellation = current_user.stop_subscript!
        redirect_to mypage_plans_path, info: "#{ cancellation.contract.plan.name }を解約しました"
    end
end
