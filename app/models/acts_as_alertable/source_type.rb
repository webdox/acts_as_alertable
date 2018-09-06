module ActsAsAlertable
	module SourceType
		def self.alerteds
			%w(user)
		end

		def self.alertables
			[]
		end

		def self.alerted_models
			self.alerteds.map{|m| m.camelize.constantize}
		end

		def self.alertable_models
			self.alertables.map{|m| m.camelize.constantize}
		end
	end
end