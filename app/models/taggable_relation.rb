require_relative 'tag_list'

module TaggableRelation
  def all_tags_alphabetical
    all_tags.alphabetical
  end

  def all_tags
    TagList(ItemTag.where(item_type: klass).includes(:tag).map(&:name))
  end

  def tagged(tag)
    joins(:tags).where(tags: {name: tag})
  end

  def new(attrs={}, &block)
    attrs = attrs.dup
    tags = attrs.delete(:tags)
    Taggable(super(attrs, &block)).tap do |item|
      item.tags = tags
    end
  end

  def klass
    defined?(super) ? super : self
  end

  def self.extended(mod)
    mod.has_many :item_tags, as: :item
    mod.has_many :tags, through: :item_tags
  end
end