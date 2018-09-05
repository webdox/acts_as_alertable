module ActsAsAlertable
	module Alertable
  		extend ActiveSupport::Concern

		included do
			has_many :alerts, as: :alertable, class_name: "ActsAsAlertable::Alert"
		end
	end
end