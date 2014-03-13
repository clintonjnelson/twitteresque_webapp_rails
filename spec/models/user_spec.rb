# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do

  # Runs the code before each example, in this case creating a new @ user using
  # User.new and a validation hash
  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: 'foobar', password_confirmation: 'foobar') }

  subject { @user }

  it { should respond_to(:name)                   }
  it { should respond_to(:email)                  }
  it { should respond_to(:password_digest)        }
  it { should respond_to(:password)               }
  it { should respond_to(:password_confirmation)  }
  it { should respond_to(:remember_token)         }
  it { should respond_to(:authenticate)           }
  it { should respond_to(:admin)                  }
  it { should respond_to(:microposts)             }
  it { should respond_to(:feed)                   }
  it { should respond_to(:relationships)          }
  it { should respond_to(:followed_users)         }   # our fake map attribute
  it { should respond_to(:follow!)                }
  it { should respond_to(:following?)             }
  it { should respond_to(:unfollow!)              }
  it { should be_valid }  # Verifies initial @user object is valid
  it { should_not be_admin }


  # This test verifies that the attributes are not empty
  describe 'when name is not present' do
    before { @user.name = '' }
    it { should_not be_valid }
  end

  describe 'when email is not present' do
    before { @user.email = '' }
    it { should_not be_valid }
  end

  # Password & confirm are equal to the empty string
  describe 'when password is not present' do
    before { @user.password = @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  # This test tries to send through a name that is too long (over 50 chars)
  describe 'when name is too long' do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  # This verifies that invalid emails are NOT allowed - provides some examples
  describe 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w[ user@foo,com user_at_foo.org example.user@foo.
                      foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  # This verifies that the email converts mixed-case to downcase
  describe 'email addresses with mixed case' do
    let (:mixed_case_email) {'Foo@ExAMPle.CoM'}

    it 'should be saved as all lower-case' do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  # This verifies that valid emails are allowed - provides some test examples
  describe 'when email format is valid' do
    it 'should be invalid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  # This tests for making sure duplicate is NOT ok
  describe 'when email address is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  # This test is insensitive to CASE
  describe 'when email address is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  # Test to make sure passwords are matching
  describe 'when password doesnt match confirmation' do
    before { @user.password_confirmation = 'mismatch'}
    it { should_not be_valid }
  end

  # Test to make sure password is not nil
  describe 'when password confirmation is nil' do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  # Test to make sure short passwords fail
  describe 'when password is too short' do
    before { @user.password = @user.password_confirmation = 'a'*5 }
    it { should be_invalid }
  end

  # Test to make usre passwords match
  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) {User.find_by_email(@user.email)}

    describe 'with valid password' do
      it { should == found_user.authenticate(@user.password)}
    end

    describe 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate('invalid')}

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "admin attribute should not be accessible" do
    it "to allow change of protected admin attribute" do
      expect do
        @user.update_attributes(admin: true)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "with admin attribute set to true" do
    before { @user.toggle!(:admin) }
    it { should be_admin }
  end

  # describe "admin should not be able to delete themselves" do
  #   it "should prevent deletion of admin" do
  #     expect do
  #       @user.destroy
  # end

  ################################# Microposts #################################
  describe "micropost associations" do
    before { @user.save }

    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      # Works because arrays are ordered - unlike hashes.
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy microposts associated with a deleted user" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        # Using prior microposts, search the db for them by id
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem Ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post)}
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost) #Feed should include each followed users micropost
        end
      end
    end
  end

  ############################### Relationships ################################
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "other users, if deleted, should destroy the relationships user had" do
      relationships = @user.relationships
      @user.destroy

      relationships.each do |relationship|
        Relationship.find_by_follower_id(relationship.follower_id).should be_nil
      end
    end

    describe "other users should be able to unfollow any followed user" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }          # direct check db
      its(:followed_users) { should_not include(other_user)} # check fake attribute
    end

    describe "followed user" do
      # Temp flip subject & user positions to check ":followers" more fluidly
      subject { other_user }
      its(:followers) { should include(@user) } #check other fake attribute (reverse lookup)
    end
  end
end




