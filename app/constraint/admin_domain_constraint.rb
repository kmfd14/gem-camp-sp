class AdminDomainConstraint
  def matches?(request)
    domains = ['admin.com']
    domains = Rails.application.config_for(:domain)[:admin]
  end
end