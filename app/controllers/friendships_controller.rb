class FriendshipsController < ApplicationController
  
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id], status: "applying")

    if @friendship.save
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
    end

    redirect_back(fallback_location: user_path(current_user))
  end

  def destroy
    if current_user.inverse_friendships.where(user_id: params[:id]).present?
      @friendship = current_user.inverse_friendships.where(user_id: params[:id])
      @friendship.destroy_all
      @user = User.find_by_id(params[:id])
      flash[:notice] = "Successfully deleted #{@user.name} from friend list"
    elsif current_user.friendships.where(friend_id: params[:id]).present?
      @friendship = current_user.friendships.where(friend_id: params[:id]) 
      @friendship.destroy_all
    end
    redirect_back(fallback_location: user_path(current_user))
  end
end
