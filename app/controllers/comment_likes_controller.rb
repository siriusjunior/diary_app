class CommentLikesController < ApplicationController
    before_action :require_login, only: %i[create destroy]

    def create
        @comment = Comment.find(params[:comment_id])
        current_user.comment_like(@comment) 
            # コメントいいねuser_idがコメントuser_idと等しいときは除外
            if current_user.id != @comment.user_id && @comment.user.notification_on_comment_like?
                UserMailer.with(user_from: current_user, user_to: @comment.user, comment: @comment).like_comment.deliver_later 
            end
    end

    def destroy
        @comment = CommentLike.find(params[:id]).comment
        current_user.comment_unlike(@comment)
    end
end
