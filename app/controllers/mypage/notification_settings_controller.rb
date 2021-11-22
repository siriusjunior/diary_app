class Mypage::NotificationSettingsController < Mypage::BaseController
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(notification_setting_params)
      redirect_to edit_mypage_notification_setting_path, success: '通知設定を更新しました'
    else
      flash.now[:danger] = "通知設定の更新に失敗しました"
      render :edit
    end
  end

  private

    def notification_setting_params
      params.require(:user).(:notification_on_comment, :notification_on_like, :notification_on_follow, :notification_on_comment_like)
    end
    
end
