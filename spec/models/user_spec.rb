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
  before { @user = User.new(name: "Example User", email: "user@example.com") }

  subject { @user }

  it { should respond_to(:name)}
  it { should respond_to(:email)}
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
end





