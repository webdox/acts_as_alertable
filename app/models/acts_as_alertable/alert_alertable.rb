module ActsAsAlertable
  class AlertAlertable < ActiveRecord::Base
    belongs_to :alert
    belongs_to :alertable, polymorphic: true

    after_create :set_alertable_for_alert

    def set_alertable_for_alert
    	alert.update_column(:alertable_type, alertable_type) unless alert.alertable_type
    end
  end
end
