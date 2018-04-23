class FriendshipsController < ApplicationController
  before_action :set_current_user
  
  def create
    @friend = User.find_by_id(params[:friend_id])

    @friendship = current_user.friendships.build(friend_id: params[:friend_id], status: "applying")
    @friendship.save

    # if @friendship.save
    # else
    #   flash[:alert] = @friendship.errors.full_messages.to_sentence
    # end
  end

  def update
    @friend = User.find_by_id(params[:id])

    @friendship = Friendship.where(friend_id: current_user.id ,user_id: params[:id], status: "applying").first
    @friendship.update(status: "friend")

    # if @friendship.update(status: "friend")
    #   flash[:notice] = "Successfully added #{@user.name} in friend list"
    # else
    #   flash[:alert] = "Fail to add friend"
    # end
  end

  def destroy
    @friend = User.find_by_id(params[:id])

    if current_user.inverse_friendships.where(user_id: params[:id]).present?
      @friendship = current_user.inverse_friendships.where(user_id: params[:id])
      @friendship.destroy_all
      # flash[:notice] = "Successfully deleted #{@user.name} from friend list"
    elsif current_user.friendships.where(friend_id: params[:id]).present?
      @friendship = current_user.friendships.where(friend_id: params[:id]) 
      @friendship.destroy_all
    end

    if request.referer.include? ('/posts/')
      render 'destroy.js.erb'
      return
    else
      render 'users/my_friend.js.erb'
      return
    end
  end

  private

  def set_current_user
    @user = current_user
  end
end
