class PasswordResetsController < ApplicationController

  def new; end

  # newビューからメールの送信
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_reset_password_instructions!
    else
      return redirect_to(new_password_reset_path, danger: "このメールアドレスは登録されていません")
    end
    return redirect_to(root_path, info: "パスワードリセットのメールを送信しました、メールをご確認ください")
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
      redirect_to(root_path, success: 'パスワードの変更が完了しました')
    else
      flash.now[:danger] = 'パスワードの変更ができませんでした'
      render :edit
    end
  end

end