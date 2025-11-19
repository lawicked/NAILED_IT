class InterviewsController < ApplicationController
 before_action :authenticate_user!

  def index
    @interviews = Interview.all

    # Filter by search query
    if params[:query].present?
      @interviews = @interviews.where("target_role ILIKE ?", "%#{params[:query]}%")
    end

    # Filter by seniority
    if params[:seniority].present? && params[:seniority] != 'All'
      @interviews = @interviews.where(seniority: params[:seniority])
    end

    # Filter by technology
    if params[:technology].present? && params[:technology] != 'All Technologies'
      @interviews = @interviews.where(language: params[:technology])
    end

    # Sort
    case params[:sort]
    when 'Newest'
      @interviews = @interviews.order(created_at: :desc)
    when 'Shortest'
      @interviews = @interviews.order(duration: :asc)
    else
      @interviews = @interviews.order(id: :desc)
    end
  end
end
