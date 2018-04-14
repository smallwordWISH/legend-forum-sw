class RepliesController < ApplicationController
  before_action :set_post, only: [:create, :update, :destroy]
  before_action :set_reply, except: [:create]

  def create
    @reply = @post.replies.build(reply_params)
    @reply.user = current_user

    if @reply.save
      flash[:notice] = "Reply was successfully created"
    else
      flash[:alert] = "Reply was failed to create. #{@reply.errors.full_messages.to_sentence}"
    end
    redirect_to post_path(@post)
  end

  def edit
  end

  def update
    @reply.update(reply_params)
    if !@reply.update(reply_params)
      flash[:alert] = "Reply was failed to update. #{@reply.errors.full_messages.to_sentence}"
      redirect_back(fallback_location: root_path)
    end
    redirect_to post_path(@post)
  end

  def destroy
    if @reply.user == current_user
      @reply.destroy
      if @reply.present?
        flash[:notice] = "Reply was successfully deleted."
      else
        flash[:alert] = "Reply does not exist."
      end
      redirect_to post_path(@post)
    else
      flash[:alert] = "You are not authorized."
      redirect_to post_path(@post)
    end
  end

  private

  def set_post
    @post = Post.find_by_id(params[:post_id])
    if !@post 
      redirect_to(root_path)
    end
  end

  def set_reply
    @reply = Reply.find_by_id(params[:id])
    if !@reply 
      redirect_to(root_path)
    end
  end

  def reply_params
    params.require(:reply).permit(:comment)
  end
end
