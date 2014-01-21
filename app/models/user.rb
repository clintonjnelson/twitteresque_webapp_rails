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

# This is a CLASS to manage a single User with respect to the User table db.
# This manages all of the data coming in from the website for the User.
# This checks validations before changing things, runs methods like downcase, etc.
# Email & Name & Password are stored in the db
# Password is conditional based on matching password_confirm. Confirm is never stored
# has_secure_password method works with password_digest in the db
    # It can create & authenticate new users too
    # It has built-in validations (good/bad) that can be turned off or added to.

class User < ActiveRecord::Base
  # Load getters/setters, & instance variables
  attr_accessible :email, :name, :password, :password_confirmation

  # Load password creator/authenticator management method
  # Uses BCrypt for encryption
  # Requires: attributes: password/password_confirmation, db column: password_digest
  has_secure_password

  # Constants
  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Callbacks (done prior to condition)
  before_save { |user| user.email = email.downcase }

  # Attribute Validation Methods
  validates(:name,    presence: true, length: { maximum: 50})
  validates(:email,   presence: true,
                      format:       { with: VALID_EMAIL_FORMAT },
                      uniqueness:   { case_sensitive: false })
  validates(:password, presence: true, length: { minimum: 6 })
  validates(:password_confirmation,   presence: true, length: { minimum: 6 })
end
