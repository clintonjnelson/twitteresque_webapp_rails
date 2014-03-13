class User < ActiveRecord::Base
  # Load getters/setters, & instance variables
  attr_accessible :email, :name, :password, :password_confirmation

  # Associations
  has_many :microposts, dependent: :destroy

  # Creating our fake attribute & how to map to it for checking
  # Says: look up follower_id to find the followed_users per :followed (followed_id) column
  # followed_users is an array attribute set to the followed_id's in the rels model
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  # Creating our fake attribute & how to map to it for checking
  # Says: look up followed_id to find the followers per :follower (follower_id) column
  # followers is an array attribute set to the follower_id's in the rels model
  # NOTE: COULD OMIT SOURCE HERE BECAUSE Rails DEFAULT is :followers -> follower_id
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships#, source: :follower

  # Load password creator/authenticator management method
  # Uses BCrypt for encryption
  # Requires: attributes: password/password_confirmation, db column: password_digest
  has_secure_password

  # Constants
  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


  # Callbacks (done prior to condition). Two versions shown
  # before_save { |user| user.email = email.downcase }
  before_save { self.email.downcase! }
  # Creates a value to save in user for tracking sessions
  before_save :create_remember_token

  # Attribute Validation Methods
  validates(:name,    presence: true, length: { maximum: 50})
  validates(:email,   presence: true,
                      format:       { with: VALID_EMAIL_FORMAT },
                      uniqueness:   { case_sensitive: false })
  validates(:password, length: { minimum: 6 })
  validates(:password_confirmation, presence: true)

  def feed
    # REST WILL BE FILLED OUT IN CHAPTER 11 FOR FOLLOWED USERS
    Micropost.from_users_followed_by(self)
  end

  ####################### RELATIONSHIPS MODEL MANAGEMENT #######################
  # Special management tools to create relations between Users through Rels Model

  def follow!(other_user)
    # Set the attr_accessible in new row
    self.relationships.create!(followed_id: other_user.id)
  end

  def following?(other_user)
    self.relationships.find_by_followed_id(other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by_followed_id(other_user.id).destroy
  end

  private
  # Method to create a random string & update the database attribute remember_token
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end

# This is a CLASS to manage a single User with respect to the User table db.
# This manages all of the data coming in from the website for the User.
# This checks validations before changing things, runs methods like downcase, etc.
# Email & Name & Password are stored in the db
# Password is conditional based on matching password_confirm. Confirm is never stored
# has_secure_password method works with password_digest in the db
    # It can create & authenticate new users too
    # It has built-in validations (good/bad) that can be turned off or added to.

