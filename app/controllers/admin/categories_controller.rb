class Admin::CategoriesController < Admin::AdminController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all.order(id: :asc)
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category was sucessfully created."
      redirect_to admin_categories_path
    else
      flash[:alert] = "Category was fail to creat. #{@category.errors.full_messages.to_sentence}"
      @categories = Category.all.order(id: :asc)
      render :index
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category was sucessfully updated."
    else
      flash[:alert] = "Category was fail to update. #{@category.errors.full_messages.to_sentence}."
      @categories = Category.order(created_at: :asc).all
    end
    
    redirect_to admin_categories_path
  end

  def destroy
    @category.destroy

    if @category.present?
      flash[:notice] = "Category was successfully deleted."
    else
      flash[:alert] = "Category does not exist."
    end
    redirect_to admin_root_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
     @category = Category.find_by_id(params[:id])
  end
end
