class CommentLikesController < ApplicationController
    before_action :require_login, only: %i[create destroy]

    def create
        @comment = Comment.find(params[:comment_id])
        current_user.comment_like(@comment)
    end

    def destroy
        @comment = CommentLike.find(params[:id]).comment
        current_user.comment_unlike(@comment)
    end
end
