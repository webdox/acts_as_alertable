require 'spec_helper'

module ActsAsAlertable
  describe Alert do
	before :all do
		AlertableArticle.destroy_all
		User.destroy_all

		@article1 = AlertableArticle.create! title: "Article #1"
		@article2 = AlertableArticle.create! title: "Article #2"
		@article3 = AlertableArticle.create! title: "Article #3"
		@alert1 = @article1.alerts.create!
		@alert2 = @article1.alerts.create! alertables_custom_method: :all
		@alert3 = ActsAsAlertable::Alert.create cron_format: '0 0 * 8 *', kind: :simple_periodic

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
				type: 'seconds',
				value: 30
			},
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
		@alert2.users << @user2
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
		it "alert1 observable_dates must be article1 and article3 created_at" do
			@alert1.observable_dates.sort.should eq([Date.today].sort)
		end

		it "alert1 kind must be date_trigger" do
			@alert1.kind.should eq('date_trigger')
		end

		it "alert1 cron_format must be '0 0 1 * *'" do
			@alert1.cron_format.should eq('0 0 1 * *')
		end

		it "comment_alert observable_dates must be comment title" do
			@comment_alert.observable_dates.should eq([@comment.release_date])
		end
	end

	context "methods" do
		it "every day of September must be sendeable for alert3 after specific date" do
			@newComment = Comment.create! title: "New Comment", release_date: Date.new(2018,9,18)
			@newAlert = @newComment.alerts.create! name: "New Alert", observable_date: :release_date, kind: :advanced_periodic, cron_format: '0 0 * 9 *', advanced_type: 'after'

			@newAlert.sendeable_date?(Date.new(2018,9,16)).should eq(false)
			@newAlert.sendeable_date?(Date.new(2018,9,17)).should eq(false)
			@newAlert.sendeable_date?(Date.new(2018,9,18)).should eq(true)
			@newAlert.sendeable_date?(Date.new(2018,9,19)).should eq(true)
			@newAlert.alertables_for_date(Date.new(2018,9,17)).should eq([])
			@newAlert.alertables_for_date(Date.new(2018,9,18)).should eq([@newComment])
		end

		it "every day of August must be sendeable for alert3" do
			@alert3.sendeable_date?(Date.new(2016,8,5)).should eq(true)
			@alert3.sendeable_date?(Date.new(2017,8,31)).should eq(true)
			@alert3.sendeable_date?(Date.new(2018,9,15)).should eq(false)
		end

		it "15 days ago must be a alert2 sendeable_date" do
			@alert2.sendeable_date?(Time.now - 15.days).should eq(true)
		end

		it "in 30 days more must NOT be a alert2 sendeable_date" do
			@alert2.sendeable_date?(Time.now + 30.days).should eq(false)
		end

		it "alert1 api_json" do
			@alert1.api_json.should eq(
				{
					id: @alert1.id,
					name: @alert1.name,
					created_at: @alert1.created_at,
					kind: @alert1.kind,
					advanced_type: @alert1.advanced_type,
					cron_format: @alert1.cron_format,
					observable_date: 'created_at',
					alertable_type: 'AlertableArticle',
					alertables_custom_method: nil,
					observable_dates: {
						@article1.created_at.to_date => [@article1.id, @article3.id]
					},
					trigger_dates: {},
					alerteds: {
						@article1.id => @alert1.users,
						@article3.id => @alert1.users,
					},
					notifications: nil
				}
			)
		end

		it "alert2 api_json" do
			@alert2.api_json.should eq(
				{
					id: @alert2.id,
					name: @alert2.name,
					created_at: @alert2.created_at,
					kind: @alert2.kind,
					advanced_type: @alert2.advanced_type,
					cron_format: @alert2.cron_format,
					observable_date: 'created_at',
					alertable_type: 'AlertableArticle',
					alertables_custom_method: 'all',
					observable_dates: {
						@article1.created_at.to_date => [@article1.id, @article2.id, @article3.id]
					},
					trigger_dates: {
						@article1.created_at.to_date - 15.days => [@article1.id, @article2.id, @article3.id],
						@article1.created_at.to_date + 30.month => [@article1.id, @article2.id, @article3.id],
						@article1.created_at.to_date => [@article1.id, @article2.id, @article3.id],
					},
					alerteds: {
						@article1.id => @alert2.users,
						@article2.id => @alert2.users,
						@article3.id => @alert2.users
					},
					notifications: @notifications1
				}
			)
		end

		it "comment_alert api_json" do
			@comment_alert.api_json.should eq(
				{
					id: @comment_alert.id,
					name: @comment_alert.name,
					created_at: @comment_alert.created_at,
					kind: @comment_alert.kind,
					advanced_type: @comment_alert.advanced_type,
					cron_format: @comment_alert.cron_format,
					observable_date: 'release_date',
					alertable_type: 'Comment',
					alertables_custom_method: nil,
					observable_dates: {
						Date.new(2020,12,12) => [@comment.id]
					},
					trigger_dates: {},
					alerteds: {
						@comment.id => @comment.users,
					},
					notifications: nil
				}
			)
		end

		it "observable_dates must be equal to api_json observable_dates keys" do
			@alert1.api_json[:observable_dates].keys.sort.should eq(@alert1.observable_dates)
			@comment_alert.api_json[:observable_dates].keys.sort.should eq(@comment_alert.observable_dates)
		end

		it "sends a notification email" do
        	expect { Alert.check! }.to change { ActionMailer::Base.deliveries.count }.by(3)
      	end
	end
  end
end
