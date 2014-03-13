class Micropost < ActiveRecord::Base
  attr_accessible :content # REMOVE :user_id for security reasons
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 140 }


  # This gets tacked on to Micropost, so that's why we need "self." in def
  # This method enables Micropost to pull values based on these many id's
  # This is likely going to be used in the users feed (see user.rb)
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
            user_id: user)
  end

  default_scope order: 'microposts.created_at DESC'
end
