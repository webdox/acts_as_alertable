require 'pry'
module ActsAsAlertable
  class Alert < ActiveRecord::Base
    belongs_to :alertable, polymorphic: true
    has_many :alert_alerteds

    ActsAsAlertable::SourceType.all.each do |source_type|
    	has_many source_type.pluralize.to_sym, :through => :alert_alerteds, :source => :alerted, :source_type => source_type.camelize
  	end
  end
end
