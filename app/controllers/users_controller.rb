class UsersController < ApplicationController

  def index
    @users = User.all.includes(:diaries, :tags).page(params[:page]).per(10).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.js
    end
    @tags = Tag.joins(:tag_links).group(:tag_id).order('count(user_id) desc')
  end

  def search
    @users = User.joins(:tag_links).where("tag_links.tag_id" => params[:id]).includes(:diaries, :tags).page(params[:page]).per(5).order(created_at: :desc)
    @tags = Tag.joins(:tag_links).group(:tag_id).order('count(user_id) desc')
    @tag = Tag.find(params[:id])
    # render :indexで@tagsが必要
    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.skip_password = true
      @user.update!(avatar: open("./app/assets/images/profile-placeholder.png"))
      # auto_login(@user)
      redirect_to login_path, info: 'メールを送信いたしました。メールをご確認の上、アカウントを有効化してください'
    else
      flash.now[:danger] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @thumbnail_diaries = @user.diaries.thumbnail
    @diaries = @user.diaries.recent(3)
    @tags = @user.tags
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      auto_login(@user)
      # ActionCableの認証処理に必要なcookies
      cookies.signed['user_id'] = current_user.id
      redirect_to login_path, info: 'アカウントの有効化が完了しました'
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

  def diaries
    @user = User.find(params[:id])
    @diaries = @user.diaries.includes(:user).page(params[:page]).per(5).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def following
    @user  = User.find(params[:id])
    @users = @user.following.includes(:diaries, :tags).page(params[:page]).per(5).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def followers
    @user  = User.find(params[:id])
    @users = @user.followers.includes(:diaries, :tags).page(params[:page]).per(5).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
    
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username)
    end
end
