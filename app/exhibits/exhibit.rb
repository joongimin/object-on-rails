require 'delegate'

class Exhibit < SimpleDelegator
  def initialize(model, context)
    @context = context
    super(model)
  end

  def to_model
    __getobj__
  end

  def class
    __getobj__.class
  end

  def self.exhibit(object, context)
    exhibits.inject(object) do |o, exhibit|
      exhibit.exhibit_if_applicable(o, context)
    end
  end

  def self.exhibit_if_applicable(object, context)
    if applicable_to?(object)
      new(object, context)
    else
      object
    end
  end

  def self.applicable_to?(object)
    false
  end

  def self.exhibits
    [
      LinkExhibit,
      TextPostExhibit,
      PicturePostExhibit
    ]
  end

  def self.object_is_any_of?(object, *classes)
    (classes.map(&:to_s) & object.class.ancestors.map(&:name)).any?
  end
end