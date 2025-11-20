class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a professional interviewer conducting a timed job interview.\n\nI am a candidate being interviewed.\n\nConduct a realistic interview by:\n- Asking ONE clear, specific question at a time\n- Listening to my complete answer WITHOUT providing feedback yet\n- Moving to the next relevant question based on my response\n- Asking questions appropriate to the interview type (technical OR behavioral)\n- Maintaining a professional, neutral tone throughout\n\nDo NOT provide feedback, scores, or commentary on my answers during the interview. Simply acknowledge my response briefly and move to your next question.\n\nThe interview will be summarized at the end with detailed feedback.\n\nAnswer concisely in Markdown."

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    @interview = @conversation.interview

    @message = Message.new(message_params)
    @message.conversation = @conversation
    @message.role = "user"

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

      @conversation.messages.create(role: "assistant", content: response.content)
      redirect_to conversation_path(@conversation)
    else
      render "chats/show", status: :unprocessable_entity
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
    "Here is the context of the interview: Position: #{@interview.target_role}. Level: #{@interview.seniority}. Technology: #{@interview.language}. Interview description: #{@interview.body}."
  end

  def instructions
    [SYSTEM_PROMPT, interview_context, @interview.system_prompt].compact.join("\n\n")
  end
end
