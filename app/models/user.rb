class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites
  has_many :book_comments
  
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # ① フォローしている人取得(Userのfollowerから見た関係)
  has_many :followings, through: :follower, source: :followed # 自分がフォローしている人
  
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy# ② フォローされている人取得(Userのfolowedから見た関係)
  has_many :followers, through: :followed, source: :follower # 自分をフォローしている人(自分がフォローされている人)
  
  
  def following?(other_user)
    follower.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    follower.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    follower.find_by(followed_id: other_user.id).destroy
  end
  
  
  
  
  
  attachment :profile_image, destroy: false

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }
end
