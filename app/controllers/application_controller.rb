class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :init_blog

  helper :exhibits

  def blog_url(*)
    root_url
  end

  private
    def init_blog
      @blog = THE_BLOG
    end

    def blog
      @blog ||= THE_BLOG
    end
    helper_method :blog
end
