class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :replies_count, :last_replied_at, :viewed_count]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :confirm_user, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:index, :replies_count, :last_replied_at, :viewed_count]
  before_action :set_category, only: [:index, :replies_count, :last_replied_at, :viewed_count]

  def index
    if params[:category_id].present?
      @posts = Post.includes(:replies, :categories).where(draft: false, categories: {id: params[:category_id]})
    else
      @posts = Post.includes(:replies).where(draft: false)
    end

    set_who_can_see_posts
  end

  def replies_count
    if params[:category_id].present?
      @posts = Post.includes(:replies, :categories).where(draft: false, categories: {id: params[:category_id]}).order(replies_count: :desc)
    else
      @posts = Post.includes(:replies).where(draft: false).order(replies_count: :desc)
    end

    set_who_can_see_posts

    render 'index.html.erb'
  end

  def last_replied_at
    if params[:category_id].present?
      @posts = Post.includes(:replies, :categories).where(draft: false, categories: {id: params[:category_id]}).order('replies.created_at DESC')
    else
      @posts = Post.includes(:replies).where(draft: false).order('replies.created_at DESC')
    end
    set_who_can_see_posts

    render 'index.html.erb'
  end

  def viewed_count
    if params[:category_id].present?
      @posts = Post.includes(:replies, :categories).where(draft: false, categories: {id: params[:category_id]}).order(views_count: :desc)
    else
      @posts = Post.includes(:replies).where(draft: false).order(views_count: :desc)
    end
    set_who_can_see_posts

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
    if !(@post.user == current_user)
      if @post.authority == 'friend' && !(current_user.is_friend?(@post.user))
        flash[:alert] = "You are not authorized."
        redirect_back(fallback_location: root_path)
      elsif @post.authority == 'myself' && !(current_user == @post.user)
        flash[:alert] = "You are not authorized."
        redirect_back(fallback_location: root_path)
      end
    end

    @reply = Reply.new
    @replies = @post.replies.page(params[:page]).per(20)
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
    params.require(:post).permit(:title, :content, :picture, :authority, :category_ids => [])
  end

  def confirm_user
    if @post.user != current_user
      flash[:alert] = "You are not authorized."
      redirect_back(fallback_location: root_path)
    end
  end
end
