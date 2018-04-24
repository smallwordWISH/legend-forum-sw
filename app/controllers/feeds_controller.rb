class FeedsController < ApplicationController
  def index
    @users_count = User.all.count
    @posts_count = Post.all.count
    @replies_count = Reply.all.count

    @users = User.all.order(replies_count: :desc).limit(10)
    @posts = Post.all.order(replies_count: :desc).limit(10)
  end
end
