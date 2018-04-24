class UsersController < ApplicationController
  before_action :set_user
  before_action :confirm_user, only: [:edit, :update]

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    if !@user.update(user_params)
      flash[:alert] = "User data was failed to update. #{@user.errors.full_messages.to_sentence}"
      redirect_back(fallback_location: root_path)
    end
    redirect_to user_path(@user)
  end

  private

  def set_user 
    @user = User.find_by_id(params[:id])
  end

  def confirm_user
    if @user != current_user
      flash[:alert] = "You are not authorized."
      redirect_back(fallback_location: root_path)
    end
  end

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end
end
