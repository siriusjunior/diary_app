class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to login_path, info: 'メールを送信いたしました。メールをご確認の上、アカウントを有効化してください'
    else
      flash.now[:danger] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to login_path, success: 'アカウントの有効化が完了しました'
    else
      not_authenticated
    end
  end

  def reset_diary_date
    @diary = Diary.new
    current_user.skip_password = true
    current_user.reset_diary
    respond_to do |format|
      flash.now[:info] = 'ダイアリー日数がリセットされました'
      format.js
      format.html
    end
  end

    private
      
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username)
      end
end
