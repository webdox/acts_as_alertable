class CreateActsAsAlertableAlertAlertables < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :acts_as_alertable_alert_alertables do |t|
      t.belongs_to :alert, index: true
      t.belongs_to :alertable, polymorphic: true

      t.timestamps null: false
    end
  end
end
