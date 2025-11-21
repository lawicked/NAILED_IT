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

    greeting_prompt = <<-PROMPT
      You are starting a #{interview.category} interview for a #{interview.seniority} #{interview.target_role} position.

      Greet the candidate warmly and professionally. Then explain:
      1. This is a structured interview with #{interview.questions.split("\n").length} questions
      2. They should answer each question thoughtfully
      3. There's no time limit - take their time

      Then ask them if they're ready to begin.

      Keep it friendly, encouraging, and concise (3-4 sentences max).
    PROMPT

    response = RubyLLM.chat.ask(greeting_prompt)

    conversation.messages.create!(
      role: "assistant",
      content: response.content
    )
  end
end
