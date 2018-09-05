require 'spec_helper'

module ActsAsAlertable
  describe Alert do
	before :all do
		@article1 = AlertableArticle.create! title: "Article #1"
		@alert1 = @article1.alerts.create!
		@alert2 = @article1.alerts.create!
		@user1 = User.create! name: 'User #1', email: "user1@alertable.com"
		@user2 = User.create! name: 'User #2', email: "user2@alertable.com"
		@alert1.users << @user1

		@comment = Comment.create!
		@comment.users << [@user1, @user2]
		@comment_alert = @comment.alerts.create!
		@comment_alert.users << @user2
	end

	context "relations" do
		it "article1 must had 2 alerts" do
			@article1.alerts.count.should eq(2)
		end

		it "alert1 must had 1 alerted user" do
			@alert1.user_alerteds.count.should eq(1)
		end

		it "alert1's alerted user must be user1" do
			@alert1.user_alerteds.first.should eq(@user1)
		end
	end

	context "default values" do
		it "alert1 trigger_date must be article1 created_at" do
			@alert1.trigger_date.should eq(@article1.created_at)
		end

		it "alert1 kind must be date_trigger" do
    		@alert1.kind.should eq('date_trigger')
    	end

    	it "comment_alert users must be article users" do
    		@comment_alert.user_alerteds.pluck(:name).should eq([@user1.name, @user2.name])
    	end
	end
  end
end
