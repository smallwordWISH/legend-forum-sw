class Category < ApplicationRecord
  has_many :posts, dependent: :destory
end
