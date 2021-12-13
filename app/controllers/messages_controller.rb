class MessagesController < ApplicationController
  before_action :require_login, only: %i[create]

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      # クライアントサイド(chatroom.js)で購読中の各ルームにbroadcast
      ActionCable.server.broadcast(
        "chatroom_#{ @message.chatroom_id }",
        # クライアントサイドでdataとしてjson形式で取得する(data.html)
        type: :create, html: (render_to_string partial: 'message', locals: { message: @message }, layout: false), message: @message.as_json
      )
      head :ok
    else
      render :errors #errors.js.slimを呼ぶ
    end
  end

  def show
    @message = current_user.messages.find(params[:id])
  end

  def edit
    @message = current_user.messages.find(params[:id])
  end

  def update
    @message = current_user.messages.find(params[:id])
    if @message.update(message_update_params)
      ActionCable.server.broadcast(
        "chatroom_#{ @message.chatroom_id }",
        type: :update, html: (render_to_string partial: 'message', locals: { message: @message }, layout: false), message: @message.as_json
      )
      head :ok
    else
      render :update #update.js.slimを呼ぶ
    end
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy!
    ActionCable.server.broadcast(
      "chatroom_#{ @message.chatroom_id }",
      type: :delete, html: (render_to_string partial: 'message', locals: { message: @message }, layout: false), message: @message.as_json
    )
    render :destroy, content_type: "text/javascript" #destroy.js.slimを呼ぶ
  end

  private

    def message_params
      params.require(:message).permit(:body).merge(chatroom_id: params[:chatroom_id])
    end

    def message_update_params
      params.require(:message).permit(:body)
    end
end
