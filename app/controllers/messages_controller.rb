class MessagesController < ApplicationController
  before_action :require_login, only: %i[create]
  def create
    @message = current_user.messages.build(message_params)
    if @message.save
    else
      # js.slimではなくcable/chatroom.jsのActionCableで実装

    end
  end

  def edit
    @message = current_user.messages.find(params[:id])
  end

  def update
    @message = current_user.messages.find(params[:id])
    if @message.update(message_update_params)
    
    else
      # js.slimではなくcable/chatroom.jsのActionCableで実装
    end
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy!
    # js.slimではなくcable/chatroom.jsのActionCableで実装
  end

  private

    def message_params
      params.require(:message).permit(:body).merge(chatroom_id: params[:chatroom_id])
    end

    def message_update_params
      params.require(:message).permit(:body)
    end
end
