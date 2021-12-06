class ChatroomsController < ApplicationController
  before_action :require_login, only: %i[index create show]
  before_action :require_user_ids, only: %i[create]
  def index
  end

  def create
    users = User.where(id: params.dig(:chatroom :user_ids)) + [current_user]
    @chatroom = Chatroom.chatroom_with_users(users)
    redirect_to chatroom_path(@chatroom)
  end
  
  def show
    @chatroom = current_user.chatrooms.find(params[:id])
  end

  private

    def require_user_ids
      redirect_back(fallback_location: root_path, danger: 'パラメーターが不正です') if params.dig(:chatroom, :user_ids).reject(&:blank?).blank?
    end

end
