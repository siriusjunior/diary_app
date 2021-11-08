class DiariesController < ApplicationController
  include SessionsHelper
  before_action :require_login, only: %i[new create update destroy]
  def index
    @diaries = if current_user
      current_user.feed.includes(:user).page(params[:page]).per(10).order(created_at: :desc)
    else
      Diary.all.includes(:user).page(params[:page]).per(10).order(created_at: :desc)
    end
  end

  def new
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
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
    if !current_user
      store_location
    end
    @diary = Diary.find(params[:id])
    @comments = @diary.comments.includes(:user).includes(:comment_likes).order(created_at: :desc).sort{|a,b| b.comment_likes.size <=> a.comment_likes.size}
    # @comments = @diary.comments.includes(:user).order(created_at: :desc)
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

  private

    def diary_params
      params.require(:diary).permit(:image, :image_cache, :check, :remove_image, :body, :comment_authorization, :date_sequence)
    end

end
