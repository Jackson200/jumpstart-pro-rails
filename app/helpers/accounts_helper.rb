module AccountsHelper
  def account_avatar(account, options = {})
    size = options[:size] || 48
    classes = options[:class]

    if account.personal? && account.owner_id == current_user&.id
      image_tag(
        avatar_url_for(account.users.first, options),
        class: classes,
        alt: account.name
      )

    elsif account.avatar.attached? && account.avatar.variable?
      image_tag(
        account.avatar.variant(resize_to_fit: [size, size]),
        class: classes,
        alt: account.name
      )
    else
      content = tag.span(account.name.to_s.first, class: "initials")

      if options[:include_user]
        content += image_tag(avatar_url_for(current_user), class: "avatar-small")
      end

      tag.span(content, class: "avatar bg-blue-500 #{classes}")
    end
  end

  def account_user_roles(account, account_user)
    roles = []
    roles << "Owner" if account_user.respond_to?(:user_id) && account.owner_id == account_user.user_id
    AccountUser::ROLES.each do |role|
      roles << role.to_s.humanize if account_user.public_send(:"#{role}?")
    end
    roles
  end

  def account_admin?(account, account_user)
    AccountUser.find_by(account: account, user: account_user).admin?
  end

  # A link to switch the account
  #
  # For session switching, we'll use a button_to and submit to the server
  # For path switching, we'll link to the path
  # For subdomains, we can simply link to the subdomain
  # For domains, we can link to the domain (assuming it's configured correctly)
  #
  # The button/link label defaults to the account name, can be overriden with either:
  #   * options[:label]
  #   * Ruby block
  def switch_account_button(account, **options, &block)
    if block
      # if Jumpstart::Multitenancy.domain? && account.domain?
      #   link_to options.fetch(:label, account.name), account.domain, options, &block
      if Jumpstart::Multitenancy.subdomain? && account.subdomain?
        link_to root_url(subdomain: account.subdomain), options, &block
      elsif Jumpstart::Multitenancy.path?
        link_to root_url(script_name: "/#{account.id}"), options, &block
      else
        button_to switch_account_path(account), options.merge(method: :patch), &block
      end
    # elsif Jumpstart::Multitenancy.domain? && account.domain?
    #   link_to options.fetch(:label, account.name), account.domain, options
    elsif Jumpstart::Multitenancy.subdomain? && account.subdomain?
      link_to options.fetch(:label, account.name), root_url(subdomain: account.subdomain), options
    elsif Jumpstart::Multitenancy.path?
      link_to options.fetch(:label, account.name), root_url(script_name: "/#{account.id}"), options
    else
      button_to options.fetch(:label, account.name), switch_account_path(account), options.merge(method: :patch)
    end
  end
end
