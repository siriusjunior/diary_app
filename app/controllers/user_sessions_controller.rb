class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password], params[:remember])
    if @user
      if session[:return_to]
        # ActionCableの認証処理に必要なcookies
        cookies.signed['user_id'] = current_user.id
        redirect_to session[:return_to], success: "ログインしました"
        session.delete(:return_to)
      else
        # ActionCableの認証処理に必要なcookies
        cookies.signed['user_id'] = current_user.id
        redirect_back_or_to diaries_url, success: "ログインしました"
      end
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def guest_login
    user = User.guest
    if user && user.activation_state == 'pending'
      user.skip_password = true
      user.update!(activation_state: "active")
    end
    auto_login(user)
    @user = user
    if @user
      if session[:return_to]
        # ActionCableの認証処理に必要なcookies
        cookies.signed['user_id'] = current_user.id
        redirect_to session[:return_to], info: "ゲストユーザーでログインしました"
        session.delete(:return_to)
      else
        # ActionCableの認証処理に必要なcookies
        cookies.signed['user_id'] = current_user.id
        redirect_back_or_to diaries_url, info: "ゲストユーザーでログインしました"
      end
    else
      flash.now[:danger] = "ゲストユーザーのログインに失敗しました"
      render :new
    end
  end

  def destroy
    logout
    cookies.delete('user_id') if !cookies['user_id'].nil?
    redirect_back_or_to root_path, success: "ログアウトしました"
  end

  def store_location
    session[:return_to] = request.referer if request.get?
    redirect_to login_path, info: "こちらからログインしてください"
  end
end
