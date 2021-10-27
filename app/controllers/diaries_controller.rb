class DiariesController < ApplicationController
  before_action :require_login, only: %i[new create update destroy]
  def index
    @diaries = Diary.all.includes(:user).order(created_at: :desc)
  end

  def new
    @diary = Diary.new
    @user = User.find(current_user.id)
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    @user = User.find(current_user.id)
    if @diary.save
      @diary.update!(date_sequence: @user.diary_date)
      @user.increment!(:diary_date, 1)
      redirect_to diaries_path
    else
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

  private

    def diary_params
      params.require(:diary).permit(:diary, :image, :body)
    end
end
