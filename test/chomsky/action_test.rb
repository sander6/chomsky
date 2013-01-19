require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Action do
  before do
    TestGrammar = Class.new(Chomsky::Grammar) do
      attr_reader :capture

      def initialize
        @capture = nil
      end
    end
    TestGrammar.rule(:foo) { `foo` }
    TestGrammar.action(:bar) { |s| @capture = s }
    TestGrammar.rule(:foobar) { foo >> bar }
    @grammar = TestGrammar.new
  end

  after do
    Object.__send__(:remove_const, :TestGrammar)
  end

  it "should call the action with the matching portion of the previous parser" do
    @grammar.foobar.("foobar")
    @grammar.capture.must_equal "foo"
  end

  it "should not change the matched portion of the input" do
    fbhead, _ = @grammar.foobar.("foobar")
    fhead, _ = @grammar.foo.("foobar")
    fbhead.must_equal fhead
  end

  it "should not change the 'rest' of the input" do
    _, fbrest = @grammar.foobar.("foobar")
    _, frest = @grammar.foo.("foobar")
    fbrest.must_equal frest
  end
end
