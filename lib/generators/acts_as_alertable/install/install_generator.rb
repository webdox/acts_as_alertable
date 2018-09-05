module ActsAsAlertable
	class InstallGenerator < Rails::Generators::NamedBase
	  source_root File.expand_path('../templates', __FILE__)

	  def copy_initializer_file
	  	copy_file "install.rb", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_acts_as_alertable_alerts.rb"
	  end

	  def migration_version
	    if Rails.version >= "5.0.0"
	      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
	    end
	  end
	end
end