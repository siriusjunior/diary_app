class CommentsController < ApplicationController
    include AjaxHelper
    before_action :require_login, only: %i[create edit update destroy]
    before_action :check_authorization, only: %i[create]

    def create
        @comment = current_user.comments.build(comment_params)
        UserMailer.with(user_from: current_user, user_to: @comment.diary.user, comment: @comment).comment_diary.deliver_later if @comment.save && @comment.diary.user.notification_on_comment?
    end

    def edit
        @comment = current_user.comments.find(params[:id])
        respond_to do |format|
            format.html
            format.js
        end
    end

    def update
        @comment = current_user.comments.find(params[:id])
        @comment.update(comment_update_params)
    end

    # def show
    #     @comment = current_user.comments.find(params[:id])
    #     respond_to do |format|
    #         format.html
    #         format.js
    #     end
    # end

    def destroy
        @comment = current_user.comments.find(params[:id])
        @comment.destroy!
    end
    
    private

        def comment_params
            params.require(:comment).permit(:body).merge(diary_id: params[:diary_id])
        end

        def comment_update_params
            params.require(:comment).permit(:body)
        end

        def check_authorization
            @diary = Diary.find(params[:diary_id])
            if !@diary.comment_authorization
                # 0つまりfalseだった場合
                respond_to do |format|
                    format.js { render ajax_redirect_to(root_path) }
                    # 想定している挙動とは違ったため保留
                    # flash.now[:danger] = 'コメントは投稿者により認められていません'
                    # format.js { render ajax_flash(flash) }
                end
            end
        end
end
