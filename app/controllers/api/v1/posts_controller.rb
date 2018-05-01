class Api::V1::PostsController < ApiController

   before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :confirm_user, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:index]
  before_action :set_category, only: [:index]

  def index
    if params[:category_id].present?
      @posts = Post.includes(:replies, :categories).where(draft: false, categories: {id: params[:category_id]})
    else
      @posts = Post.includes(:replies).where(draft: false)
    end

    set_who_can_see_posts

    render json: {
      data: @posts
    }
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if params[:commit] == 'Save Draft'
      @post.draft = true
      if @post.save
        render json: {
          message: "Draft was successfully saved.",
          result: @post
        }
      else
        render json: {
          message: "Draft was failed to saved.",
          errors: @post.errors
        }
      end
    else 
      if @post.save
        render json: {
          message: "Post was successfully created.",
          result: @post
        }
      else
        render json: {
          message: "Post was failed to created.",
          errors: @post.errors
        }
      end
    end    
  end
  
  def show
    
    if !@post
      render json: {
        message: "Can't find the post!",
        status: 400
      }
      return
    end

    if !(@post.user == current_user)
      if @post.authority == 'friend' && !(current_user.is_friend?(@post.user))
        render json: {
          message: "You are not authorized.",
          status: 400
        }
        return
      elsif @post.authority == 'myself' && !(current_user == @post.user)
        render json: {
          message: "You are not authorized.",
          status: 400
        }
        return
      elsif @post.draft == true
        render json: {
          message: "You are not authorized.",
          status: 400
        }
        return      
      end 
    end

    # @reply = Reply.new
    # @replies = @post.replies.page(params[:page]).per(20)
    @user = @post.user

    if !current_user.views.where(post_id: params[:id]).present?
      @view = current_user.views.build(post_id: params[:id])
      @view.save
    end

    render json: {
        data: @post
    } 
  end


  def update
    @post.update(post_params)

    if !@post.update(post_params)
      flash[:alert] = "Post was failed to update. #{@post.errors.full_messages.to_sentence}"
      redirect_back(fallback_location: root_path)
    end

    redirect_to post_path(@post)
  end

  def destroy
    @post.destroy
    if @post.present?
      flash[:notice] = "Post was successfully deleted."
    else
      flash[:alert] = "post does not exist."
    end
    redirect_to root_path
  end

  private

  def set_post
    @post = Post.find_by_id(params[:id])
  end

  def set_who_can_see_posts
    @posts.each do |post|
      if !current_user 
        @posts = @posts.where(authority: "all") 
      elsif post.authority == 'friend'
        if !(current_user.is_friend?(post.user))
          @posts = @posts.includes(:user).where.not(id: post.id)
        end
      elsif post.authority == 'myself'
        if !(current_user == post.user)
          @posts = @posts.includes(:user).where.not(id: post.id)
        end
      end
    end
    @posts = @posts.page(params[:page]).per(20)
  end

  def set_categories
    @categories = Category.all
  end

  def set_category
    if params[:category_id].present?
      @category = Category.find_by_id(params[:category_id])
    end
  end

  def post_params
    params.permit(:title, :content, :picture, :authority, :draft, :category_ids => [])
  end

  def confirm_user
    if @post.user != current_user
      flash[:alert] = "You are not authorized."
      redirect_back(fallback_location: root_path)
    end
  end
  
end
