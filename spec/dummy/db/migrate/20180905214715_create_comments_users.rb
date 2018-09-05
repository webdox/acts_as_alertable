class CreateCommentsUsers < ActiveRecord::Migration
  def change
    create_table :comments_users do |t|
      t.belongs_to :comment, index: true
      t.belongs_to :user, index: true
    end
  end
end
