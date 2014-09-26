class AdminEmailer < ActionMailer::Base
  default from: "Triple R Farms <#{ENV["EMAIL_USERNAME"]}>"

  def feedback_email(feedback)
    @feedback = feedback
    @emails = admin_emails
    mail(to: @emails, subject: "[Triple-R-Farms] Feedback")
  end

  def order_email(order)
    @order = order
    @emails = admin_emails
    mail(to: @emails, subject: "[Triple-R-Farms] Order")
  end

  private
  def admin_emails
    User.admins.pluck(:email, :additional_emails).compact.map{|a| a.split(",")}.flatten.compact
  end
end
