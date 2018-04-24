class Post < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates_presence_of :content, :authority, :title
  
  belongs_to :user

  has_and_belongs_to_many :categories

  has_many :replies, dependent: :destroy
  has_many :views, dependent: :destroy
  # has_many :favorites, dependent: :destroy

end
