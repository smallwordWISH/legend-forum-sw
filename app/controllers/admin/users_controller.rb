class Admin::UsersController < Admin::AdminController
  before_action :set_user

  def index
    @users = User.all.order(id: :asc).page(params[:page]).per(20)
  end

  def update
    if @user.email == 'admin@example.com'
      flash[:alert] = "Origin admin's role can not be changed."
      redirect_to admin_users_path
      return
    end

    if @user.update(user_params)
      flash[:notice] = "User role is updated."
    else
      flash[:notice] = "User role is fail to update."
    end

    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
