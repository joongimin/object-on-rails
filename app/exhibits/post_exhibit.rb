require_relative 'exhibit'

class PostExhibit < Exhibit
  include ::Conversions

  def self.applicable_to?(object)
    object_is_any_of?(object, 'Post')
  end

  def tags
    exhibit(Taggable(to_model).tags)
  end
end