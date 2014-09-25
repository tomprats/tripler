class AdminEmailer < ActionMailer::Base
  default from: "Triple R Farms <#{ENV["EMAIL_USERNAME"]}>"

  def feedback_email(feedback)
    @feedback = feedback
    @emails = User.admins.pluck(:email)
    mail(to: @emails, subject: "[Triple-R-Farms] Feedback")
  end

  def order_email(order)
    @order = order
    @emails = User.admins.pluck(:email)
    mail(to: @emails, subject: "[Triple-R-Farms] Order")
  end
end
