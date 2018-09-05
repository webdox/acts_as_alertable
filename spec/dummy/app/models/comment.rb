class Comment < ActiveRecord::Base
	include ActsAsAlertable::Alertable

	has_and_belongs_to_many :users

	def alerteds
		users
	end
end
