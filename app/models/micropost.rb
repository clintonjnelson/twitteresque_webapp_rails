class Micropost < ActiveRecord::Base
  attr_accessible :content # REMOVE :user_id for security reasons
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 140 }

  default_scope order: 'microposts.created_at DESC'
end
