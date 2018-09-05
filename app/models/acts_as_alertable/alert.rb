require 'pry'
module ActsAsAlertable
  class Alert < ActiveRecord::Base
    belongs_to :alertable, polymorphic: true
    has_many :alert_alerteds

    # edit this list on config/initializers/source_types.rb
    ActsAsAlertable::SourceType.all.each do |source_type|
    	has_many source_type.pluralize.to_sym, :through => :alert_alerteds, :source => :alerted, :source_type => source_type.camelize
  	end

  	enum kind: [:date_trigger, :simple_periodic, :advanced_periodic]

  	# Alert instance Methods
  	def observable
		observable_date || 'created_at'
	end

	def trigger_date
		alertable.try(observable)
	end

	def user_alerteds
		alertable.try(:alerteds) || users
	end
  end
end
