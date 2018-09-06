require 'pry'
module ActsAsAlertable
  class Alert < ActiveRecord::Base
  	has_many :alert_alertables
    has_many :alert_alerteds

    serialize :notifications

    # edit this list on config/initializers/source_types.rb
    ActsAsAlertable::SourceType.alerteds.each do |alerted_model|
    	has_many alerted_model.pluralize.to_sym, :through => :alert_alerteds, :source => :alerted, :source_type => alerted_model.camelize
  	end

  	ActsAsAlertable::SourceType.alertables.each do |alertable_model|
    	has_many alertable_model.pluralize.to_sym, :through => :alert_alertables, :source => :alertable, :source_type => alertable_model.camelize
  	end

  	enum kind: [:date_trigger, :simple_periodic, :advanced_periodic]

  	# Alert instance Methods
  	def observable
		observable_date || 'created_at'
	end

	def alertables
		alertable_model.send(alertables_custom_method) rescue self.send(alertable_type.underscore.pluralize)
	end

	def alertable_model
		alertable_type.constantize
	end

	def trigger_dates
		return alertables.pluck(observable).map(&:to_date).uniq if alertable_model.attribute_names.include?(observable)

		alertables.map{|a| a.send(observable).to_date}.uniq
	end

	def user_alerteds
		alertables.map{|a| a.alerteds_for(self)}.flatten.uniq
	end

	def sendeable_date? date
		trigger_dates.map{|d|d.to_date}.include?(date.to_date)
	end

	def trigger_dates_object
		result = {}
		alertables.each{|a| result[a.send(observable).to_date] = result[a.send(observable).to_date].to_a << a.id}
		result
	end

	def alerteds_object
		alertables.map{|a| [a.id, a.alerteds_for(self)]}.to_h
	end

	def api_json
		{
			id: id,
			name: name,
			observable: observable,
			alertable_type: alertable_type,
			alertables_custom_method: alertables_custom_method,
			trigger_dates: trigger_dates_object,
			alerteds: alerteds_object,
			notifications: notifications
		}
	end
  end
end
