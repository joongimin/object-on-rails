require_relative '../spec_helper_lite'
require_relative '../../app/exhibits/enumerable_exhibit'

describe EnumerableExhibit do
  subject { EnumerableExhibit.new(model, context) }
  let(:model) { %w[e1 e2 e3] }
  let(:context) { Object.new }

  before do
    stub(subject).exhibit {|model|
      @last_exhibited = model
      "exhibit(#{model})"
    }
  end

  describe '#each' do
    it 'exhibits each element' do
      results = []
      subject.each do |e| results << e end
      results.must_equal(%w[exhibit(e1) exhibit(e2) exhibit(e3)])
    end
  end

  describe '#grep' do
    it 'exhibits the result set' do
      subject.grep(/[12]/).must_equal('exhibit(["e1", "e2"])')
    end
  end

  describe '#select' do
    it 'exhibits each result' do
      subject.select{|e| /[23]/ === e}.must_equal('exhibit(["e2", "e3"])')
    end
  end

  describe '#[]' do
    it 'exhibits the result' do
      subject[1].must_equal('exhibit(e2)')
    end
  end

  describe '#group_by' do
    it 'exhibits the result' do
      subject.group_by{|e| e == 'e2'}.
        must_equal({
          true => 'exhibit(["e2"])',
          false => 'exhibit(["e1", "e3"])'
          })
    end
  end
end