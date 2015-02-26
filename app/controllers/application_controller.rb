class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper :exhibits

  def blog_url(*)
    root_url
  end

  private
    def blog
      @blog ||= THE_BLOG
    end
    helper_method :blog
end
