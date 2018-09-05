require 'spec_helper'

module ActsAsAlertable
  describe Alert do
    before :all do
    	@article1 = AlertableArticle.create! title: "Article #1"
    end

    context "relations" do
    	it "article1 must had 2 alerts" do
    		2.times.each{@article1.alerts.create!}
    		@article1.alerts.count.should eq(2)
    	end
    end
  end
end
