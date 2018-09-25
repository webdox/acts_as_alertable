class CreateActsAsAlertableAlerts < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :acts_as_alertable_alerts do |t|
      t.string :alertable_type
      t.string :name
      t.string :observable_date
      t.integer :kind, default: 0
      t.integer :advanced_type, default: 0
      t.string :cron_format, default: "0 0 1 * *" #every month
      t.string :alertables_custom_method
      t.text :notifications

      t.timestamps null: false
    end
  end
end
