class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a professional interviewer conducting a structured interview.\n\nAcknowledge the candidate's answer briefly (1-2 sentences) without providing detailed feedback yet.\n\nThen ask the next question from the interview template.\n\nMaintain a professional, encouraging tone.\n\nAll feedback will be provided in a comprehensive summary at the end."

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    @interview = @conversation.interview
    params.delete(:authenticity_token)
    params.delete(:commit)
    params.delete(:conversation_id)
    @message = Message.new(message_params)
    @message.conversation = @conversation
    @message.role = "user"

    if @message.save
      user_answers_count = @conversation.messages.where(role: "user").count
      total_questions = @interview.questions.split("\n").length

      if user_answers_count >= total_questions
        @conversation.generate_interview_summary

        summary_message = "Thank you for completing the interview! Here's your comprehensive feedback:\n\n#{@conversation.summary}"
        Message.create(role: "assistant", content: summary_message, conversation: @conversation)
      else
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: response.content, conversation: @conversation)
      end

      # @conversation.messages.create(role: "assistant", content: response.content)
      redirect_to conversation_path(@conversation)
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
    params.permit(:content)
  end

  def interview_context
    "Here is the context of the interview: Position: #{@interview.target_role}. Level: #{@interview.seniority}. Technology: #{@interview.language}.\n\nYou must ask these questions in order:\n#{@interview.questions}\n\nAsk them ONE at a time."
  end

  def instructions
    [SYSTEM_PROMPT, interview_context, @interview.system_prompt].compact.join("\n\n")
  end

end
