class AddReleaseDateToComment < ActiveRecord::Migration
  def change
    add_column :comments, :release_date, :date
  end
end
