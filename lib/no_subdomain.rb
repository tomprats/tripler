class NoSubdomain
  def self.matches?(request)
    !request.subdomain.present? || request.subdomain == "www" || request.subdomain == "triplerfarms"
  end
end
