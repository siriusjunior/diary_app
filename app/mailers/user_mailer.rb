class UserMailer < ApplicationMailer

  def activation_needed_email(user)
    @user = user
    @url = "http://localhost:3000/users/#{user.activation_token}/activate"
    mail(to: user.email, subject: "ダイアリー体験フォーラムのご登録ありがとうございます")
  end

  def activation_success_email(user)
    @user = user
    @url = "http://localhost:3000/login"
    mail(to: user.email, subject: "アカウントの有効化が完了しました")
  end
end
