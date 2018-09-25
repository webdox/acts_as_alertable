require "spec_helper"

module ActsAsAlertable
  describe AlertMailer do
    describe "notify" do
      let(:mail) do
        @user = User.create! email: 'test@user.com'
        @article = AlertableArticle.create! title: 'Article1'
        @alert = @article.alerts.create name: 'Alerta!'
        AlertMailer.notify(@user, @article, @alert)
      end

      it "renders the headers" do
        mail.subject.should eq("[#{Alert.model_name.human}] #{@alert.name} | #{@article.descriptive_name}")
        mail.to.should eq([@user.email])
        mail.from.should eq(["from@example.com"])
      end

      it "renders the body" do
        mail.body.encoded.include?("<h1>AlertMailer#notify</h1>").should eq(true)
      end
    end

  end
end
