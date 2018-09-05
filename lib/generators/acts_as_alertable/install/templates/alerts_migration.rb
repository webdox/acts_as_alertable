class CreateActsAsAlertableAlerts < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :acts_as_alertable_alerts do |t|
      t.belongs_to :alertable, polymorphic: true
      t.string :name
      t.string :observable_date
      t.integer :kind, default: 0

      t.timestamps null: false
    end
  end
end
