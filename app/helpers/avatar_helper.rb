module AvatarHelper
  def avatar_url_for(user, opts = {})
    size = opts[:size] || 48

    if user.respond_to?(:avatar) && user.avatar.attached? && user.avatar.variable?
      user.avatar.variant(resize_to_fit: [size, size])
    else
      gravatar_url_for(user.email, size: size)
    end
  end
end
