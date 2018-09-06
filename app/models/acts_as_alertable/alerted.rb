module ActsAsAlertable
	module Alerted
  		extend ActiveSupport::Concern

		included do
			has_many :alert_alerteds, as: :alerted, class_name: "ActsAsAlertable::AlertAlerted"
    		has_many :alerts, through: :alert_alerteds, class_name: "ActsAsAlertable::Alert"
		end

		def descriptive_name
			"#{self.class.model_name.human} ##{self.id}"
		end

		def descriptive_email
			email rescue "#{self.class.to_s.underscore}@alerted.com"
		end
	end
end