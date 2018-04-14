class UsersController < ApplicationController
  before_action :set_user

  def show
  end

  def edit
    if @user == current_user
    else
      flash[:alert] = "You are not authorized."
      redirect_to user_path(@user)
    end
  end

  def update
    @user.update(user_params)
    if !@user.update(user_params)
      flash[:alert] = "User data was failed to update. #{@user.errors.full_messages.to_sentence}"
      redirect_back(fallback_location: root_path)
    end
    redirect_to user_path(@user)
  end

  def set_user 
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end
end
