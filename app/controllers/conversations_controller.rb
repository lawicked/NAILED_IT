class ConversationsController < ApplicationController
  # app/controllers/chats_controller.rb
  def create
    @interview = Interview.find(params[:interview_id])

    @conversation = Conversation.new(title: "Untitled")
    @conversation.challenge = @conversation
    @conversation.user = current_user

    if @conversation.save
      redirect_to conversation_path(@conversation)
    else
      render "interviews/show"
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
    @interview = @conversation.interview
    @messages = @conversation.messages.order(created_at: :asc)
    @message = Message.new
  end
end
