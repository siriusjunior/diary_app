class DiariesController < ApplicationController
  before_action :require_login, only: %i[new create update destroy]
  def index
    @diaries = Diary.all.includes(:user).order(created_at: :desc)
  end

  def new
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      redirect_to diaries_path, success: 'ダイアリーを投稿しました'
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
      redirect_to diaries_path
    else
      render :edit
    end
  end

  def show
    @diary = Diary.find(params[:id])
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
      params.require(:diary).permit(:image, :image_cache, :remove_image, :body, :date_sequence)
    end

end
