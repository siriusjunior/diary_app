class LikesController < ApplicationController
    before_action :require_login, only: %i[create destroy]

    def create
        @diary = Diary.find(params[:diary_id])
        UserMailer.with(user_from: current_user, user_to: @diary.user, diary: @diary).like_diary.deliver_later if current_user.like(@diary)
    end

    def destroy
        @diary = Like.find(params[:id]).diary
        current_user.unlike(@diary)
    end
end
