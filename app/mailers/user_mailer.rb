class UserMailer < ApplicationMailer

  def activation_needed_email(user)
    @user = user
    @url = "https://www.diaryapp.net/users/#{user.activation_token}/activate"
    mail(to: user.email, subject: "ダイアリー体験フォーラムのご登録ありがとうございます")
  end

  def activation_success_email(user)
    @user = user
    @url = "https://www.diaryapp.net/login"
    mail(to: user.email, subject: "アカウントの有効化が完了しました")
  end

  def reset_password_email(user)
    @user = user
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email, subject: "パスワードの再登録を行なってください")
  end

  def comment_diary
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    @comment = params[:comment]
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたのダイアリーにコメントしました")
  end
  
  def like_diary
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    @diary = params[:diary]
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたのダイアリーにいいねしました")
  end
  
  def follow
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたをフォローしました")
  end

  def like_comment
    @user_from = params[:user_from]
    @user_to = params[:user_to]
    @comment = params[:comment]
    mail(to: @user_to.email, subject: "#{@user_from.username}があなたのコメントにいいねしました")
  end

end
