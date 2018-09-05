module ActsAsAlertable
  class Engine < ::Rails::Engine
    isolate_namespace ActsAsAlertable
    config.generators do |g|
		g.test_framework :rspec
	end
  end
end
