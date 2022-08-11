module ConnectedAccountsHelper
  def social_icon(provider, options = {})
    icon = provider_config(provider)[:icon]
    fa_icon icon, options.merge(weight: "fa-brands") if icon
  end

  def provider_config(provider)
    _, config = Jumpstart::Omniauth::AVAILABLE_PROVIDERS.find { |_, config| config[:provider].to_s == provider.to_s }
    config || {name: provider.to_s.humanize}
  end
end
