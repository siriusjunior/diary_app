class Mypage::AccountsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
    @account_form = AccountForm.new(user: @user)
    @labels = @user.tags.pluck(:name).join(',')
  end

  def update
    @user = User.find(current_user.id)
    @user.skip_password = true
    @account_form = AccountForm.new(account_params, user: @user)
    if @account_form.valid?
      @account_form.save
      redirect_to user_path(@user), info: 'プロフィールを更新しました'
    else
      flash.now[:danger] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  private
  
    def account_params
      params.require(:user).permit(:username, :introduction, :avatar, :avatar_cache, :labels)
    end
end
