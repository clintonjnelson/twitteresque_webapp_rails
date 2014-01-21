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
  it { should respond_to(:authenticate)           }
  it { should be_valid }  # Verifies initial @user object is valid

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
end




