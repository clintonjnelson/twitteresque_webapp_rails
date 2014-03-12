require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  # This method AUTO SETS the user_id to the user's ID, thus explicit define is not needed
  before { @micropost = user.microposts.build(content: 'ipsum lorem') }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }   #verify associated to user.id
  its(:user) { should == user }     # @micropost's user should == our :user id
  it { should be_valid }


  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "when content is blank" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    before { @micropost.content = ("a"*141) }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        # WHY NOT USE THE MICROPOSTS CONSTRUCTOR HERE????
        # user.microposts.build(user_id: user.id)
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
