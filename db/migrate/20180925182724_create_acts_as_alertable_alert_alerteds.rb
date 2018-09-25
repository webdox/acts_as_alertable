class CreateActsAsAlertableAlertAlerteds < ActiveRecord::Migration
  def change
    create_table :acts_as_alertable_alert_alerteds do |t|
      t.belongs_to :alert, index: true
      t.belongs_to :alerted, polymorphic: true

      t.timestamps null: false
    end
  end
end
