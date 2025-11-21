class ConversationsController < ApplicationController
   before_action :authenticate_user!

  def show
    @conversation = Conversation.find(params[:id])
    @message = Message.new
  end

  def create
    @interview = Interview.find(params[:interview_id])

    @conversation = Conversation.new(title: "#{@interview.target_role} Practice Interview (#{@interview.seniority})")
    @conversation.interview = @interview
    @conversation.user = current_user

    if @conversation.save
      generate_opening_message(@conversation)
      redirect_to conversation_path(@conversation)
    else
      render "interviews/index"
    end
  end

  private

  def generate_opening_message(conversation)
    interview = conversation.interview
    question_count = interview.questions.split("\n").length
    first_question = conversation.current_question

  greeting = <<~GREETING
    👋 **Welcome to your #{interview.target_role} interview!**

    Interview Details
    - Position: #{interview.target_role}
    - Level: #{interview.seniority}
    - Category: #{interview.category}
    - Technology: #{interview.language}
    - Questions: #{question_count}

    **How it works**

    I'll ask you #{question_count} questions, one at a time. Take your time to answer each question thoughtfully. After answering all questions, you'll automatically receive comprehensive feedback.

    **Let's begin with your first question:**

    #{first_question}
  GREETING

    conversation.messages.create!(
      role: "assistant",
      content: greeting
    )
  end
end
