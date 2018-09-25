module ActsAsAlertable
  class AlertMailer < ApplicationMailer

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.alert_mailer.notify.subject
    #
    def notify alerted, alertable, alert
      @alert = alert
      @alerted = alerted
      @alertable = alertable

      mail to: @alerted.descriptive_email, subject: "[#{ActsAsAlertable::Alert.model_name.human}] #{@alert.name} | #{@alertable.descriptive_name}"
    end
  end
end
