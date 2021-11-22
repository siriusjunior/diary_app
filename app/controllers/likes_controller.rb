class LikesController < ApplicationController
    before_action :require_login, only: %i[create destroy]

    def create
        @diary = Diary.find(params[:diary_id])
        current_user.like(@diary)
        # いいねuser_idがダイアリーuser_idと等しいときは除外
        if  current_user.id != @diary.user_id && @diary.user.notification_on_like?
            UserMailer.with(user_from: current_user, user_to: @diary.user, diary: @diary).like_diary.deliver_later
        end
    end

    def destroy
        @diary = Like.find(params[:id]).diary
        current_user.unlike(@diary)
    end
end
