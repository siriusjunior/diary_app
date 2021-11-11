class Mypage::AccountsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    @user.skip_password = true
    if @user.update(account_params)
      redirect_to user_path(@user), info: 'プロフィールを更新しました'
    else
      flash.now[:danger] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  private
  
    def account_params
      params.require(:user).permit(:username, :introduction, :avatar, :avatar_cache)
    end
end
