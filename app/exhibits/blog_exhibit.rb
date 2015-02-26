class BlogExhibit < Exhibit
  exhibit_query :filter_by_tag, :entries

  def self.applicable_to?(object)
    object_is_any_of?(object, 'Blog', 'Blog::FilteredBlog')
  end
end