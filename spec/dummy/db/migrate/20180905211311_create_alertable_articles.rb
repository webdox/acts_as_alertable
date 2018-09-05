class CreateAlertableArticles < ActiveRecord::Migration
  def change
    create_table :alertable_articles do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
