# frozen_string_literal: true

module ApplicationHelper
  def user_avatar(_user)
    asset_path('user.png')
  end

  def flash_class(level)
    case level
    when 'info' then 'alert alert-info'
    when 'notice', 'success' then 'alert alert-success'
    when 'error' then 'alert alert-danger'
    when 'alert' then 'alert alert-warning'
    end
  end
end
