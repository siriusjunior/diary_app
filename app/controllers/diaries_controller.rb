class DiariesController < ApplicationController
  include SessionsHelper
  before_action :require_login, only: %i[new create update destroy]
  before_action :check_diary_post, only: %i[new create]
  def index
    if current_user
      if current_user.have_following?
        # ログインユーザーでフィードデータがある場合
        @diaries = current_user.feed.includes(:user, :comments, :likes).page(params[:page]).per(10).order(created_at: :desc)
        @title = "みんなの最新ダイアリー"
      else
        # ログインユーザーでフォロワーがいない場合で
        if current_user.diaries.any?
          # ダイアリーが1件以上ある場合
          @diaries = current_user.self_feed.includes(:user, :comments, :likes).page(params[:page]).per(10).order(created_at: :desc)
          @title = "あなたの最新ダイアリー"
        else
          # ダイアリーが1件もない場合
          @diaries = Diary.all.includes(:user, :comments, :likes).page(params[:page]).per(10).order(created_at: :desc)
          @title = "みんなの最新ダイアリー"
        end
      end
    else
      # ログインユーザーでない場合
      @diaries = Diary.all.includes(:user, :comments, :likes).page(params[:page]).per(10).order(created_at: :desc)
      @title = "みんなの最新ダイアリー"
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
      redirect_to diary_path(@diary), success: "ダイアリーの変更を保存しました"
    else
      flash.now[:danger] = 'ダイアリーの保存に失敗しました'
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
