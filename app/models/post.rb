require 'date'
require 'active_record'
require 'fig_leaf'

class Post < ActiveRecord::Base
  include FigLeaf
  hide ActiveRecord::Base, ancestors: true, except: [
    Object,
    :init_with,
    :new_record?,
    :errors,
    :valid?,
    :save,
    :serializable_hash,
    :read_attribute_for_validation,
    :has_transactional_callbacks?,
    :set_transaction_state,
    :record_timestamps,
    :partial_writes,
    :id,
    :id=,
    :model_name
  ]
  hide_singletons ActiveRecord::Calculations,
                  ActiveRecord::FinderMethods,
                  ActiveRecord::Relation

  validates :title, presence: true
  attr_accessor :blog

  def self.most_recent(limit=10)
    all.order(pubdate: :desc).limit(limit)
  end

  def self.first_before(date)
    where('pubdate < ?', date).order(pubdate: :desc).first
  end

  def self.first_after(date)
    where('pubdate > ?', date).order(pubdate: :asc).first
  end

  def prev
    self.class.first_before(pubdate)
  end

  def next
    self.class.first_after(pubdate)
  end

  def up
    blog
  end

  def picture?
    image_url.present?
  end

  def publish(clock = DateTime)
    return false unless valid?
    self.pubdate = clock.now
    @blog.add_entry(self)
  end

  def save(*)
    set_default_body
    super
  end

  private
    def set_default_body
      if body.blank?
        self.body = 'Nothing to see here'
      end
    end
end