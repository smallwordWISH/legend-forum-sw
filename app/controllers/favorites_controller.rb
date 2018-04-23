class FavoritesController < ApplicationController

  def create
    @post = Post.find_by_id(params[:post_id])
    @favorite = current_user.favorites.build(post_id: params[:post_id]) 

    if @favorite.save
      flash[:notice] = "Successfully collect the post."
    else
      flash[:alert] = @favorite.errors.full_messages.to_sentence
    end
  end

  def destroy
    @post = Post.find_by_id(params[:id])
    @favorite = current_user.favorites.where(post_id: params[:id])

    @favorite.destroy_all
    flash[:notice] = "Successfully deleted the post from collect list"
  end
end
