require 'minitest/autorun'
require 'rr'
require 'ostruct'
$: << File.expand_path('../lib', File.dirname(__FILE__))

# def stub_module(full_name)
#   stub_class_or_module(full_name, Module)
# end

# def stub_class(full_name)
#   stub_class_or_module(full_name, Class)
# end

# def stub_class_or_module(full_name, kind)
#   full_name.to_s.split(/::/).inject(Object) do |context, name|
#     begin
#       context.const_get(name)
#     rescue NameError
#       mod = Module.new do
#         define_method(:const_missing) do |missing_const_name|
#           if missing_const_name.to_s == name.to_s
#             value = kind.new
#             const_set(name, value)
#             value
#           else
#             super(missing_const_name)
#           end
#         end
#       end
#       context.extend(mod)
#     end
#   end
# end

def stub_module(full_name)
  full_name.to_s.split(/::/).inject(Object) do |context, name|
    begin
      context.const_get(name)
    rescue NameError
      context.const_set(name, Module.new)
    end
  end
end

module ClassStub
  def new(*args)
    super()
  end
end

def stub_class(full_name)
  full_name.to_s.split(/::/).inject(Object) do |context, name|
    begin
      context.const_get(name)
    rescue NameError
      new_class = Class.new
      new_class.extend(ClassStub)
      context.const_set(name, new_class)
    end
  end
end