class TagsController < ApplicationController
    def index
        @tags = Tag.where('name LIKE(?)', "%#{params[:keyword]}%")
        respond_to do |format| 
            format.json { render '/mypage/account/edit', json: @tags } #json形式のデータを受け取ったら、@usersをデータとして返す そしてindexをrenderで表示する
        end
    end
end
