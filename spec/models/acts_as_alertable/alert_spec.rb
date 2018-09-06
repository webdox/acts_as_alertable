require 'spec_helper'

module ActsAsAlertable
  describe Alert do
	before :all do
		AlertableArticle.destroy_all
		@article1 = AlertableArticle.create! title: "Article #1"
		@article2 = AlertableArticle.create! title: "Article #2"
		@article3 = AlertableArticle.create! title: "Article #3"
		@alert1 = @article1.alerts.create!
		@alert2 = @article1.alerts.create! alertables_custom_method: :all

		@user1 = User.create! name: 'User #1', email: "user1@alertable.com"
		@user2 = User.create! name: 'User #2', email: "user2@alertable.com"

		@comment = Comment.create! title: "Comment #1", release_date: Date.new(2020,12,12)

		@article3.alerts << @alert1
		@article2.alerts << @alert2
		@alert1.users << @user1

		@comment.users << [@user1, @user2]
		@comment_alert = @comment.alerts.create! observable_date: :release_date
		@comment_alert.users << @user2

		@notifications1 = [
			{
				type: 'days',
				value: -15
			},
			{
				type: 'month',
				value: 30
			}
		]

		@alert2.update notifications: @notifications1
	end

	context "relations" do
		it "alert1 must had 2 alertables" do
			@alert1.alertables.pluck(:title).sort.should eq([@article1.title, @article3.title].sort)
		end

		it "alert2 must had all articles as alertables" do
			@alert2.alertables.pluck(:title).sort.should eq(AlertableArticle.pluck(:title).sort)
		end

		it "article1 must had 2 alerts" do
			@article1.alerts.count.should eq(2)
		end

		it "alert1 must had 1 alerted user" do
			@alert1.user_alerteds.count.should eq(1)
		end

		it "alert1's alerted user must be user1" do
			@alert1.user_alerteds.first.should eq(@user1)
		end

		it "article2 must had alert2" do
			@article2.alerts.first.should eq(@alert2)
		end

		it "comment_alert users must be article users" do
			@comment_alert.user_alerteds.map(&:name).should eq([@user1.name, @user2.name])
		end
	end

	context "notifications" do
		it "alerts must had serialize notifications" do
			@alert1.notifications.should eq(nil)
			@alert2.notifications.should eq(@notifications1)
		end
	end

	context "default values" do
		it "alert1 trigger_dates must be article1 and article3 created_at" do
			@alert1.trigger_dates.sort.should eq([Date.today].sort)
		end

		it "alert1 kind must be date_trigger" do
			@alert1.kind.should eq('date_trigger')
		end

		it "alert1 cron_format must be '0 0 1 * *'" do
			@alert1.cron_format.should eq('0 0 1 * *')
		end

		it "comment_alert trigger_dates must be comment title" do
			@comment_alert.trigger_dates.should eq([@comment.release_date])
		end
	end

	context "methods" do
		it "today must be a alert1 sendeable_date" do
			@alert1.sendeable_date?(Time.now).should eq(true)
		end

		it "tomorrow must NOT be a alert1 sendeable_date" do
			@alert1.sendeable_date?(Time.now + 1.day).should eq(false)
		end

		it "alert1 api_json" do
			@alert1.api_json.should eq(
				{
					id: @alert1.id,
					name: @alert1.name,
					observable: 'created_at',
					alertable_type: 'AlertableArticle',
					alertables_custom_method: nil,
					trigger_dates: {
						@article1.created_at.to_date => [@article1.id, @article3.id]
					},
					alerteds: {
						@article1.id => @alert1.users,
						@article3.id => @alert1.users,
					},
					notifications: nil
				}
			)
		end

		it "comment_alert api_json" do
			@comment_alert.api_json.should eq(
				{
					id: @comment_alert.id,
					name: @comment_alert.name,
					observable: 'release_date',
					alertable_type: 'Comment',
					alertables_custom_method: nil,
					trigger_dates: {
						Date.new(2020,12,12) => [@comment.id]
					},
					alerteds: {
						@comment.id => @comment.users,
					},
					notifications: nil
				}
			)
		end

		it "trigger_dates must be equal to api_json trigger_dates keys" do
			@alert1.api_json[:trigger_dates].keys.sort.should eq(@alert1.trigger_dates)
			@comment_alert.api_json[:trigger_dates].keys.sort.should eq(@comment_alert.trigger_dates)
		end
	end
  end
end
