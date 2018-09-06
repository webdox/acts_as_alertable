ActsAsAlertable.setup do |config|
  config.alertables = %w(alertable_article comment)
  config.alerteds = %w(user)
end