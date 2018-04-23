class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :posts, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :views, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post

  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where(friendships: {status: "friend"})}, through: :friendships
  has_many :send_applies, -> { where(friendships: {status: "applying"})}, through: :friendships, source: :friend

  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :applyers, -> { where(friendships: {status: "applying"})}, through: :inverse_friendships, source: :user
  has_many :applyer_friends, -> { where(friendships: {status: "friend"})}, through: :inverse_friendships, source: :user

  def is_admin?
    self.role == "admin"
  end

  def is_friend?(user)
    if self.friends.include?(user) or self.applyer_friends.include?(user)
      return true
    else
      return false
    end
  end

  def is_be_applying?(user)
    if self.applyers.include?(user)
      return true
    else
      return false
    end
  end

  def is_applying?(user)
    if self.send_applies.include?(user)
      return true
    else
      return false
    end
  end
end
