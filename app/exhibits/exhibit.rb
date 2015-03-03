require 'delegate'

class Exhibit < SimpleDelegator
  attr_reader :context

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

  def exhibit(model)
    Exhibit.exhibit(model, context)
  end

  def to_partial_path
    if __getobj__.respond_to?(:to_partial_path)
      __getobj__.to_partial_path
    else
      partialize_name(__getobj__.class.name)
    end
  end

  def render(template)
    template.render(partial: to_partial_path, object: self)
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
      EnumerableExhibit,
      BlogExhibit,
      TextPostExhibit,
      PicturePostExhibit,
      LinkExhibit,
      TagListExhibit
    ]
  end

  def self.object_is_any_of?(object, *classes)
    (classes.map(&:to_s) & object.class.ancestors.map(&:name)).any?
  end
  private_class_method :object_is_any_of?

  def self.exhibit_query(*method_names)
    method_names.each do |method_name|
      define_method(method_name) do |*args, &block|
        exhibit(super(*args, &block))
      end
    end
  end
  private_class_method :exhibit_query

  def self.exhibit_enum(*method_names, &post_process)
    post_process ||= ->(result){exhibit(result)}
    method_names.each do |method_name|
      define_method(method_name) do |*args, &block|
        result = __getobj__.public_send(method_name, *args, &block)
        instance_exec(result, &post_process)
      end
    end
  end
  private_class_method :exhibit_enum

  private
    def partialize_name(name)
      "/#{name.underscore.pluralize}/#{name.demodulize.underscore}"
    end
end