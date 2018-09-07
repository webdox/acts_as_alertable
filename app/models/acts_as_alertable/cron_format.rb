require 'fugit'

module ActsAsAlertable
  class CronFormat

  	def self.date_match? cron_format, date
		_cron = Fugit::Cron.new(cron_format)
		_cron.match?(date)
  	end
  end
end