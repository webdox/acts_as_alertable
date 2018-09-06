module ActsAsAlertable
	module Alertable
  		extend ActiveSupport::Concern

		included do
			has_many :alert_alertables, as: :alertable, class_name: "ActsAsAlertable::AlertAlertable"
    		has_many :alerts, through: :alert_alertables, class_name: "ActsAsAlertable::Alert"
		end

		def alerteds_for(alert)
			alert.users
		end

		def descriptive_name
			"#{self.class.model_name.human} ##{self.id}"
		end
	end
end