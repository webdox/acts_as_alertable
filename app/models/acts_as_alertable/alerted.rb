module ActsAsAlertable
	module Alerted
  		extend ActiveSupport::Concern

		included do
			has_many :alert_alerteds, as: :alerted, class_name: "ActsAsAlertable::AlertAlerted"
    		has_many :alerts, through: :alert_alerteds, class_name: "ActsAsAlertable::Alert"
		end
	end
end