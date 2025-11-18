class InterviewsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @interviews = Interview.all
  end
end
