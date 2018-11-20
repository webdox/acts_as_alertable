module ActsAsAlertable
  class Alert < ActiveRecord::Base
  	has_many :alert_alertables
    has_many :alert_alerteds

    serialize :notifications

    # edit this list on config/initializers/source_types.rb
    def self.get_models
    	ActiveRecord::Base.connection.tables.map{|m| m.camelize.singularize.constantize rescue nil} - [nil]
    end

    def self.alertable_models
    	self.get_models.select{|m| m.included_modules.include?(ActsAsAlertable::Alertable)}
    end

    def self.alerteds_models
    	self.get_models.select{|m| m.included_modules.include?(ActsAsAlertable::Alerted)}
    end

    self.alerteds_models.each do |alerted_model|
    	has_many alerted_model.to_s.underscore.pluralize.to_sym, :through => :alert_alerteds, :source => :alerted, :source_type => alerted_model.to_s
  	end

  	self.alertable_models.each do |alertable_model|
    	has_many alertable_model.to_s.underscore.pluralize.to_sym, :through => :alert_alertables, :source => :alertable, :source_type => alertable_model.to_s
  	end

  	enum kind: [:date_trigger, :simple_periodic, :advanced_periodic]
  	enum advanced_type: [:before, :after]

  	# Alert instance Methods
  	def observable
		observable_date || 'created_at'
	end

	def alertables
		alertable_model.send(alertables_custom_method) rescue self.send(alertable_type.underscore.pluralize).map{|a| a.send(alertables_custom_method)}.flatten rescue self.send(alertable_type.underscore.pluralize)
	end

	def alertable_model
		alertable_type.constantize
	end

	def observable_dates
		return (alertables.pluck(observable).map{|e| e.try(:to_date)}.uniq - [nil]) if alertable_model.attribute_names.include?(observable)

		alertables.map{|a| a.send(observable).try(:to_date)}.uniq - [nil]
	end

	def trigger_dates
		return [] if !notifications || kind != 'date_trigger'

		result = observable_dates.map do |d|
			notifications.map{|n| (d + notification_value(n)).to_date}
		end
		result.flatten
	end

	def user_alerteds
		alertables.map{|a| a.alerteds_for(self)}.flatten.uniq
	end

	def advanced_type_operator
		return "<=" if advanced_type == 'before'
		return '>='
	end

	def sendeable_date? date
		return trigger_dates.map{|d|d.to_date}.include?(date.to_date) if kind == 'date_trigger'
		return cron_match?(date) if kind == "simple_periodic"
		sendeable = false
		observable_dates.each do |_date|
			sendeable ||= date.send(advanced_type_operator, _date)
			break if sendeable
		end
		sendeable && cron_match?(date)
	end

	def cron_match? date
		ActsAsAlertable::CronFormat.date_match?(cron_format, date)
	end

	def observable_dates_object
		result = {}
		alertables.each do |a|
			_date = a.send(observable).try(:to_date)
			next unless _date
			result[_date] = result[_date].to_a << a.id
		end
		result
	end

	def trigger_dates_object
		result = {}
		return result if !notifications || kind != 'date_trigger'

		alertables.each do |a|
			notifications.each do |n|
				_date = a.send(observable).try(:to_date)
				next unless _date
				date = (_date + notification_value(n)).to_date
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
			created_at: created_at,
			kind: kind,
			advanced_type: advanced_type,
			cron_format: cron_format,
			observable_date: observable,
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
		results = {}
		self.all.each do |alert|
			result = alert.check_for(date)
			results["alert_#{alert.id}"] = result if result.any?
		end
		results
	end

	def check_for date=Date.today
		return [] unless sendeable_date?(date)
		send_notifications(date)
	end

	def alertables_for_date date
		ids = trigger_dates_object[date] if kind == 'date_trigger'
		ids = alertables.map{|a| a.id } if kind == 'simple_periodic'
		ids = alertables.select{|a| date.send(advanced_type_operator, a.send(observable))}.map{|a| a.id } if kind == 'advanced_periodic'
		alertables.select{|e| ids.include?(e.id)}
	end

	def custom_trigger
		result = false
		result ||= alertable_model.try(:trigger_acts_as_alertable, self)
		self.send(alertable_type.underscore.pluralize).map{|a| result ||= a.try(:trigger_acts_as_alertable, self)}
		result
	end

	def send_notifications date
		results = []
		return results if custom_trigger
		alertables_for_date(date).each do |alertable|
			alertable.alerteds_for(self).each do |alerted|
				results << self.notify(alerted, alertable)
			end
		end
		results
	end

	def notify alerted, alertable
		result = {alerted_type: alerted.class.to_s, alerted_id: alerted.id, alertable_type: alertable.class.to_s, alertable_id: alertable.id}
		begin
			ActsAsAlertable::AlertMailer.notify(alerted, alertable, self).deliver
			result.merge(success: true)
		rescue => e
			result.merge({success: false, error: e})
		end
	end
  end
end
