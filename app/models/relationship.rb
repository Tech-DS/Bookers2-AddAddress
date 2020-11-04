class Relationship < ApplicationRecord
  
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  
  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
 
  # ユーザーをアンフォローする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
end
