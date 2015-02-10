require 'time'
require_relative '../spec_helper_full'

describe Post do
  include SpecHelpers
  before do
    setup_database
    @it = Blog.new
  end

  after do
    teardown_database
  end

  def make_post(attrs)
    attrs[:title] ||= "Post #{attrs.hash}"
    post = @it.new_post(attrs)
    post.publish.must_equal(true)
    post
  end

  it "defaults body to 'Nothing to see here'" do
    post = make_post(body: '')
    post.body.must_equal('Nothing to see here')
  end
end