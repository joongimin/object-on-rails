class BlogController < ApplicationController
  def index
  end

  private
    def blog
      if params[:tag].present?
        super.filter_by_tag(params[:tag])
      else
        super
      end
    end
end