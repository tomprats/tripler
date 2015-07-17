module AdminApp
  class FeedbackController < AdminApplicationController
    def index
      @feedback = Feedback.all
    end
  end
end
