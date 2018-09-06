class User < ActiveRecord::Base
	include ActsAsAlertable::Alerted

	has_and_belongs_to_many :comments
end
