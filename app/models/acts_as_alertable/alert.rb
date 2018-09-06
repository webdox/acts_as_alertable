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

	def observable_dates
		return alertables.pluck(observable).map(&:to_date).uniq if alertable_model.attribute_names.include?(observable)

		alertables.map{|a| a.send(observable).to_date}.uniq
	end

	def trigger_dates
		return [] if !notifications || kind != 'date_trigger'

		result = observable_dates.map do |d|
			notifications.map{|n| d + notification_value(n)}
		end
		result.flatten
	end

	def user_alerteds
		alertables.map{|a| a.alerteds_for(self)}.flatten.uniq
	end

	def sendeable_date? date
		trigger_dates.map{|d|d.to_date}.include?(date.to_date)
	end

	def observable_dates_object
		result = {}
		alertables.each{|a| result[a.send(observable).to_date] = result[a.send(observable).to_date].to_a << a.id}
		result
	end

	def trigger_dates_object
		result = {}
		return result if !notifications || kind != 'date_trigger'

		alertables.each do |a|
			notifications.each do |n|
				date = a.send(observable).to_date + notification_value(n)
				result[date] = result[date].to_a << a.id
			end
		end
		result
	end

	def alerteds_object
		alertables.map{|a| [a.id, a.alerteds_for(self)]}.to_h
	end

	def notification_value n
		n[:value].try(n[:type])
	end

	def api_json
		{
			id: id,
			name: name,
			observable: observable,
			alertable_type: alertable_type,
			alertables_custom_method: alertables_custom_method,
			observable_dates: observable_dates_object,
			trigger_dates: trigger_dates_object,
			alerteds: alerteds_object,
			notifications: notifications
		}
	end

	def self.check!
		self.check_for(Date.today)
	end

	def self.check_for date=Date.today
		self.all.each{|alert| alert.check_for(date)}
	end

	def check_for date=Date.today
		return unless trigger_dates.include?(date)
		send_notifications(date)
	end

	def send_notifications date
		ids = trigger_dates_object[date]
		alertable_model.where(id: ids).each do |alertable|
			alertable.alerteds_for(alert).each do |alerted|
				alert.notify(alerted, alertable)
			end
		end
	end

	def notify alerted, alertable
		ActsAsAlertable::AlertMailer.notify(alerted, alertable).deliver
	end
  end
end
