class LikesController < ApplicationController
    before_action :require_login, only: %i[create destroy]

    def create
        @diary = Diary.find(params[:diary_id])
        current_user.like(@diary)
    end

    def destroy
        @diary = Like.find(params[:id]).diary
        current_user.unlike(@diary)
    end
end
