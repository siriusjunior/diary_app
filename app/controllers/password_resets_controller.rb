class PasswordResetsController < ApplicationController
  before_action :check_normal, only: %i[create]

  def new; end

  # newビューからメールの送信
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_reset_password_instructions!
    else
      return redirect_to(new_password_reset_path, danger: "このメールアドレスは登録されていません")
    end
    return redirect_to(root_path, info: "パスワードリセットメールを送信しました、メールをご確認ください")
  end

  # editビューから新規パスワードを登録
  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
    if @user.blank?
      not_authenticated
      return
    end
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to(root_path, info: 'パスワードの変更が完了しました')
    else
      flash.now[:danger] = 'パスワード変更に失敗しました'
      render :edit
    end
  end

  private

    def check_normal
      if params[:email].downcase == 'guest@example.com'
        redirect_to new_password_reset_path, danger: 'ゲストユーザーのパスワードの再設定はできません'
      end
    end

end
