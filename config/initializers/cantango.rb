CanTango.config do |config|
  config.engines.all :on
  config.guest.user Guest.new
  config.cache_engine.set :off
  #config.cache.store.default_type = :memory
end

CanTango.config.user do |user|
  user.clear! # set user settings back to default
  user.unique_key_field = :email
end

CanTango.config.users.register :user
