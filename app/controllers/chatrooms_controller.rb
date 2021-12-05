class ChatroomsController < ApplicationController
  before_action :require_login, only: %i[show]
  def index
  end

  def create
  end
  
  def show
    @chatroom = current_user.chatrooms.find(params[:id])
  end
end
