# frozen_string_literal: true

json.array! @users do |user|
  json.partial! 'users/user', user: user
end
