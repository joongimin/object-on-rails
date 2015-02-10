require_relative 'exhibit'

class LinkExhibit < Exhibit
  RELATIONS = %w[next prev up]

  def self.applicable_to?(object)
    object_is_any_of?(object, 'Post')
  end

  def prev_url
    @context.url_for(prev)
  end

  def next_url
    @context.url_for(self.next)
  end

  def up_url
    @context.url_for(up)
  end

  def links_hash
    {
      'links' => RELATIONS.map {|rel|
        {'rel' => rel, 'href' => send("#{rel}_url")}
      }
    }
  end

  def serializable_hash(*)
    super.merge(links_hash)
  end

  def to_json(options={})
    serializable_hash(options).to_json
  end
end