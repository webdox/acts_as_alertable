module ActsAsAlertable
	module SourceType
		def self.alerteds
			%w(user)
		end

		def self.alertables
			%w(alertable_article comment)
		end
	end
end