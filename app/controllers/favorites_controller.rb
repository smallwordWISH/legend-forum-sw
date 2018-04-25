class FavoritesController < ApplicationController

  def create
    @post = Post.find_by_id(params[:post_id])
    @favorite = current_user.favorites.build(post_id: params[:post_id]) 

    @favorite.save
  end

  def destroy
    @post = Post.find_by_id(params[:id])
    @favorite = current_user.favorites.where(post_id: params[:id])

    @favorite.destroy_all
  end
end
