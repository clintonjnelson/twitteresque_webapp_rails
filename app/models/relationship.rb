class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  # Must specify class because follower/followed are not classes themselves
  # Essentially this says it belonds to User, but we'll call them follower/followed
  belongs_to :follower, class_name: "User"  #will make follower_id out of this
  belongs_to :followed, class_name: "User"  #will make followed_id out of this

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
