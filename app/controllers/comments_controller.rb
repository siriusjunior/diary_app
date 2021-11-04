class CommentsController < ApplicationController
    before_action :require_login, only: %i[create edit update destroy]

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
end
