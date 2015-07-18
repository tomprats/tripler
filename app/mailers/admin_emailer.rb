class AdminEmailer < ActionMailer::Base
  default from: "Triple R Farms <#{ENV["EMAIL_USERNAME"]}>"

  before_action :set_host

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

  def error_email(order, error)
    @order = order
    @error = error

    mail(to: "tprats108@gmail.com", subject: "[Triple-R-Farms] Error")
  end

  private
  def admin_emails
    User.admins.pluck(:email, :additional_emails).compact.map{|a| a.split(",")}.flatten.compact
  end

  def set_host
    AdminEmailer.default_url_options[:host] = ENV["ADMIN_HOST"]
  end
end
