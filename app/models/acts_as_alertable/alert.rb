module ActsAsAlertable
  class Alert < ActiveRecord::Base
    belongs_to :alertable
  end
end
