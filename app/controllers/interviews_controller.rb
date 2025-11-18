class InterviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @interviews = Interview.all
  end

  #  def show
  #   @interview = Interview.find(params[:id])
  # end

end
