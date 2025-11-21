class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a professional interviewer conducting a structured interview.\n\nAcknowledge the candidate's answer briefly (1-2 sentences) without providing detailed feedback yet.\n\nThen ask the next question from the interview template.\n\nMaintain a professional, encouraging tone.\n\nAll feedback will be provided in a comprehensive summary at the end."

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    @message = Message.new(message_params)
    @message.conversation = @conversation
    @message.role = "user"

if @message.save
  @conversation.advance_question!

  if @conversation.completed?
    @conversation.generate_interview_summary

    summary_message = "🎉 Thank you for completing the interview! You've answered all #{@conversation.total_questions} questions.\n\nHere's your comprehensive feedback:\n\n#{@conversation.summary}"
    Message.create!(role: "assistant", content: summary_message, conversation: @conversation)
  else
    next_question = @conversation.current_question

    prompt = <<~PROMPT
      The candidate just answered: "#{@message.content}"

      Briefly acknowledge their answer (1-2 sentences).

      Then ask this next question in a natural way:
      #{next_question}
    PROMPT

    response = RubyLLM.chat.with_instructions(SYSTEM_PROMPT).ask(prompt)
    Message.create!(role: "assistant", content: response.content, conversation: @conversation)
  end

      #@conversation.messages.create(role: "assistant", content: response.content)
      # redirect_to conversation_path(@conversation)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to conversation_path(@conversation) }
      end
    else
      # render "chats/show", status: :unprocessable_entity
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "conversations/form", locals: { conversation: @conversation, message: Message.new }) }
          format.html { render "chats/show", status: :unprocessable_entity }
        end
    end
  end

  def build_conversation_history
    @conversation.messages.each do |message|
      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
