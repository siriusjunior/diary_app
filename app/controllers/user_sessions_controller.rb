class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password], params[:remember])
    if @user
      if session[:return_to]
        # ActionCableの認証処理に必要なcookies
        cookies.signed['user.id'] = current_user.id
        redirect_to session[:return_to], success: "ログインしました"
        session.delete(:return_to)
      else
        # ActionCableの認証処理に必要なcookies
        cookies.signed['user.id'] = current_user.id
        redirect_back_or_to diaries_url, success: "ログインしました"
      end
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    logout
    cookies.delete('user.id')
    redirect_back_or_to root_path, success: "ログアウトしました"
  end

  def store_location
    session[:return_to] = request.referer if request.get?
    redirect_to login_path, info: "こちらからログインしてください"
  end
end
