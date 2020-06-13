# frozen_string_literal: true

module ApplicationHelper
  def user_avatar(_user)
    if current_user.avatar_url?
      current_user.avatar_url.url
    else
      asset_path('user.png')
    end
  end

  def flash_class(level)
    case level
    when 'info' then 'alert alert-info'
    when 'notice', 'success' then 'alert alert-dark'
    when 'error' then 'alert alert-danger'
    when 'alert' then 'alert alert-warning'
    end
  end

  def current_user_friends
    User.where(id: current_user.active_friendships.pluck(:friend_id))
  end
end
