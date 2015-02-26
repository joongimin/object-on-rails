require_relative 'exhibit'

class EnumerableExhibit < Exhibit
  include Enumerable
  exhibit_query :[], :fetch, :slice, :values_At, :last
  exhibit_enum :select, :grep, :reject, :to_enum, :sort, :sort_by, :reverse
  exhibit_enum :partition do |result|
    result.map{|group| exhibit(group)}
  end
  exhibit_enum :group_by do |result|
    result.inject({}) {|h, (k,v)|
      h.merge!(k => exhibit(v))
    }
  end

  def self.applicable_to?(object)
    object_is_any_of?(object, 'Enumerable', 'ActiveRecord::Relation')
  end

  def each(*)
    super do |e|
      yield exhibit(e)
    end
  end

  def to_ary
    self
  end
end