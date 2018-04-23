class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:index, :replies_count, :last_replied_at, :viewed_count]

  def index
    @posts = Post.where(draft: false).includes(:replies).page(params[:page]).per(20)
  end

  def replies_count
    @posts = Post.where(draft: false).includes(:replies).order(replies_count: :desc).page(params[:page]).per(20)

    render 'index.html.erb'
  end

  def last_replied_at
    @posts = Post.where(draft: false).joins(:replies).includes(:replies).order('replies.created_at DESC').page(params[:page]).per(20)

    render 'index.html.erb'
  end

  def viewed_count
    @posts = Post.where(draft: false).includes(:replies).order(views_count: :desc).page(params[:page]).per(20)

    render 'index.html.erb'
  end

  def new
    @post = Post.new 
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if params[:commit] == 'Draft'
      @post.draft = true
      if @post.save
        flash[:notice] = "Draft was successfully saved."
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "Draft was failed to saved. #{@post.errors.full_messages.to_sentence}"
        render "new"
      end
    else 
      if @post.save
        flash[:notice] = "Post was successfully created."
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "Post was failed to created. #{@post.errors.full_messages.to_sentence}"
        render "new"
      end
    end    
  end
  
  def show
    @reply = Reply.new
    @user = @post.user

    if !current_user.views.where(post_id: params[:id]).present?
      @view = current_user.views.build(post_id: params[:id])
      @view.save
    end
  end

  def edit
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

  def set_categories
    @categories = Category.all
  end

  def post_params
    params.require(:post).permit(:title, :content, :picture, :authority, :category_id)
  end
end
