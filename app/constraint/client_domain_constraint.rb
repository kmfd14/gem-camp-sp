class ClientDomainConstraint
  def matches?(request)
    domains = ['client.com']
    domains = Rails.application.config_for(:domain)[:client]
  end
end