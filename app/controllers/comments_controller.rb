class CommentsController < ApplicationController
    include AjaxHelper
    before_action :require_login, only: %i[create edit update destroy]
    before_action :check_authorization, only: %i[create edit]

    def create
        @comment = current_user.comments.build(comment_params)
        @comment.save
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

    def show
        @comment = current_user.comments.find(params[:id])
        respond_to do |format|
            format.html
            format.js
        end
    end

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
                    # flash.now[:danger] = 'コメントは投稿者により認められていません'
                    format.js { render ajax_flash(flash) }
                end
            end
        end
end