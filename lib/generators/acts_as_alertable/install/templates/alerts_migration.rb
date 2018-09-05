class CreateActsAsAlertableAlerts < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :acts_as_alertable_alerts do |t|
      t.belongs_to :alertable, polymorphic: true
      t.string :observable_date

      t.timestamps null: false
    end
  end
end
