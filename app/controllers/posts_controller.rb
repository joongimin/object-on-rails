class PostsController < ApplicationController
  include ExhibitsHelper

  respond_to :html, :json

  def new
    @post = @blog.new_post
  end

  def create
    @post = Taggable(@blog.new_post(post_params))
    if @post.publish
      redirect_to root_path, notice: 'Post added!'
    else
      render 'new'
    end
  end

  def show
    @post = exhibit(Post.find_by_id(params[:id]), self)
    respond_with(@post)
  end

  private
    def post_params
      params.require(:post).permit(:title, :body, :image_url, :tags)
    end

    attr_reader :post
    helper_method :post
end