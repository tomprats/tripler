class FeedbackController < ApplicationController
  def create
    if current_user
      feedback = current_user.feedback.create(feedback_params)
    else
      feedback = Feedback.create(feedback_params)
    end
    if feedback.valid?
      AdminEmailer.feedback_email(feedback).deliver
      render json: { status: 200, message: "Thank you for your feedback, we'll do our best to get back to you as soon as possible!" }
    else
      render json: { status: 400, message: feedback.errors.full_messages }
    end
  end

  def index
    @feedback = Feedback.all
  end

  private
  def feedback_params
    params.require(:feedback).permit(
      :name,
      :email,
      :message
    )
  end
end
