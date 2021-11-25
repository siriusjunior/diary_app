class DiariesController < ApplicationController
  include SessionsHelper
  before_action :require_login, only: %i[new create update destroy]
  before_action :check_diary_post, only: %i[new create]
  def index
    @diaries = if current_user
      if current_user.feed.any?
        # ログインユーザーでフィードデータがある場合
        current_user.feed.includes(:user).page(params[:page]).per(10).order(created_at: :desc)
      else
        # ログインユーザーでフィードデータがない場合
        Diary.all.includes(:user).page(params[:page]).per(10).order(created_at: :desc)
      end
    else
      # ログインユーザーでない場合
      Diary.all.includes(:user).page(params[:page]).per(10).order(created_at: :desc)
    end
  end

  def new
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    @diary.register_date_sequence
    if @diary.save
      redirect_to diaries_path, success: "ダイアリー#{@diary.date_sequence}日目を投稿しました"
      @diary.increment_diary_date
    else
      flash.now[:danger] = 'ダイアリーの投稿に失敗しました'
      render :new
    end
  end

  def edit
    @diary = current_user.diaries.find(params[:id])
  end

  def update
    @diary = current_user.diaries.find(params[:id])
    if @diary.update(diary_params)
      redirect_to diary_path(@diary)
    else
      render :edit
    end
  end

  def show
    @diary = Diary.find(params[:id])
    @comments = @diary.comments.includes(:user).includes(:comment_likes).order(created_at: :desc).sort{|a,b| b.comment_likes.size <=> a.comment_likes.size}
    @comment = Comment.new
  end

  def destroy
    @diary = current_user.diaries.find(params[:id])
    @diary.destroy!
    redirect_to root_path, success: 'ダイアリーを削除しました'
  end

  def reset_image
    @diary = Diary.find(params[:id])
    @diary.update_attribute(:image, nil)
    respond_to do |format|
      format.js
      format.html { render :edit }
    end
  end

  def search
    if @search_form.body.present?
      @diaries = @search_form.search.includes(:user).page(params[:page]).per(10).order(created_at: :desc)
      # flash.now[:info] = 'ダイアリーを検索しました'
    else
      redirect_to request.referer, danger: '検索ワードを入力してください'
    end
  end

  # def order
  #   @diaries = Diary.sort(params[:term]).page(params[:page]).per(5)
  #   respond_to do |format| 
  #     format.html { render :index }
  #     format.js
  #   end
  # end

  private

    def diary_params
      params.require(:diary).permit(:image, :image_cache, :check, :remove_image, :body, :comment_authorization, :date_sequence)
    end

    def search_diary_params
      params.fetch(:q, {}).permit(:body)
    end

    def check_diary_post
      if current_user.cannot_post?
        redirect_to diaries_path, danger: "ダイアリーの投稿は１日１回までです"
      end
    end
end
