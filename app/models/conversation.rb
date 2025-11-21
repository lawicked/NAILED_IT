class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :interview

  has_many :messages, dependent: :destroy
  has_many :reports, dependent: :destroy

  SUMMARY_PROMPT = <<-PROMPT
    You are a professional interviewer providing comprehensive post-interview feedback.

    Review the entire interview conversation and provide detailed evaluation in this EXACT format:

    ## Overall Performance
    [2-3 sentences summarizing the candidate's overall performance across all questions]

    ## Key Strengths
    - [Specific strength with example from their answers]
    - [Specific strength with example from their answers]
    - [Specific strength with example from their answers]

    ## Areas for Improvement
    - [Specific area with actionable advice]
    - [Specific area with actionable advice]
    - [Specific area with actionable advice]

    ## Question-by-Question Analysis

    Create a detailed table analyzing each question. For each question:
    - Summarize what the candidate said
    - Describe what an ideal answer would include
    - Provide a score out of 10

    | Question | Candidate's Answer | Ideal Answer Should Include | Score |
    |----------|-------------------|----------------------------|-------|
    | [Brief question] | [Key points they mentioned] | [Key elements of a strong answer] | X/10 |

    ## Final Recommendation
    **[Strong Hire / Hire / Maybe / No Hire]**

    [2-3 sentences justifying the recommendation based on technical skills, communication, and overall performance]

    Be specific, honest, and constructive. Focus on what they did well AND what they can improve.
  PROMPT

  def generate_interview_summary
    return if messages.empty?


    conversation_history = messages.order(:created_at).map do |msg|
      "#{msg.role.upcase}: #{msg.content}"
    end.join("\n\n")


    interview_context = <<-CONTEXT
      Interview Details:
      - Position: #{interview.target_role}
      - Level: #{interview.seniority}
      - Technology: #{interview.language}
      - Category: #{interview.category}

      Questions that were asked:
      #{interview.questions}
    CONTEXT


    full_prompt = "#{SUMMARY_PROMPT}\n\n#{interview_context}\n\nInterview Transcript:\n\n#{conversation_history}"


    response = RubyLLM.chat.ask(full_prompt)
    update(summary: response.content)
  end
end
