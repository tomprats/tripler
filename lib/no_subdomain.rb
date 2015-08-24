class NoSubdomain
  def self.matches?(request)
    !request.subdomain.present? || ["www", "triplerfarms", "staging", "triplerfarms-staging"].include?(request.subdomain)
  end
end
