Rails.application.config.sorcery.submodules = [:remember_me, :user_activation, :reset_password]

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.stretches = 1 if Rails.env.test?
    # ログイン維持時間の設定2週間が1209600なので1/14の86400の1日で設定
    user.remember_me_for = 86400
    user.user_activation_mailer = UserMailer
    user.reset_password_mailer = UserMailer
  end
  config.user_class = "User"
end
