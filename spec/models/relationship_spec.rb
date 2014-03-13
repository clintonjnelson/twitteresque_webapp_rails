require 'spec_helper'

describe Relationships do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }
    # Note how it passes the hash!

  subject { relationship }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to the follower_id" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "follower methods" do
    # Checks to make sure it has columns loaded with our users info
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }

    # Sets follower/followed & checks to make sure the id's are loaded correctly
    its(:follower) { should == follower }
    its(:followed) { should == followed }
  end

  # Validations checks
  describe "when follower_id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end

  describe "when followed_id is not present" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end
end
