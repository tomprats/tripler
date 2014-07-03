class AdminSubdomain
  def self.matches?(request)
    request.subdomain.downcase == "admin"
  end
end
