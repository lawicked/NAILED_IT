class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = Message.new(message_params)
    @message.conversation = @conversation
    @message.role = "user"

    if @message.save
      redirect_to conversation_path(@conversation), notice: "Message sent successfully."
    else
      redirect_to conversation_path(@conversation), alert: "Failed to send message."
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
