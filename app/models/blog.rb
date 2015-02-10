class Blog
  attr_reader :entries
  attr_writer :post_source

  def self.model_name
    ActiveModel::Name.new(self)
  end

  def model_name
    self.class.model_name
  end

  def to_model
    self
  end

  def persisted?
    true
  end

  def initialize(entry_fetcher=Post.public_method(:most_recent))
    @entry_fetcher = entry_fetcher
  end

  def title
    'Watching Paint Dry'
  end

  def subtitle
    'The trusted source for drying paint news & opinion'
  end

  def new_post(*args)
    post_source.call(*args).tap do |p|
      p.blog = self
    end
  end

  def add_entry(entry)
    entry.save
  end

  def entries
    fetch_entries
  end

  def fetch_entries
    @entry_fetcher.()
  end

  private
    def post_source
      @post_source ||= Post.public_method(:new)
    end
end