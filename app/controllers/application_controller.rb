class ApplicationController < ActionController::Base
  include ExhibitsHelper

  protect_from_forgery with: :exception

  helper :exhibits

  def blog_url(*)
    root_url
  end

  private
    def blog
      @blog ||= exhibit(THE_BLOG)
    end
    helper_method :blog
end
