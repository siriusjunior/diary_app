class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password], params[:remember])
    if @user
      redirect_back_or_to session[:return_to], success: "ログインしました"
      session.delete(:return_to)
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    logout
    redirect_back_or_to root_path, success: "ログアウトしました"
  end
end
