class ConversationsController < ApplicationController
  # app/controllers/chats_controller.rb
  def show
    @conversation = Conversation.find(params[:id])
  end

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
end
