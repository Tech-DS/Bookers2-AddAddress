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
  
  
  
  def self.search(search,word)
    if search == "forward_match"
                 @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
                 @user = User.where("name LIKE?","%#{word}")
    elsif search == "perfect_match"
                 @user = User.where(name: "#{word}")
    elsif search == "partial_match"
                 @user = User.where("name LIKE?","%#{word}%")
    else
       @user = User.all
    end
  end
  
  
  def prefecture_name
      JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end   
   
  def prefecture_name=(prefecture_name)
      self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  
  
  attachment :profile_image, destroy: false

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }
end
