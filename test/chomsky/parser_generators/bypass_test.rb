require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Bypass do
  before do
    TestGrammar = Class.new(Chomsky::Grammar) do
      attr_reader :capture
    end
    TestGrammar.rule(:foo) { `foo` }
    TestGrammar.rule(:bar) { `bar` }
    TestGrammar.action(:rev) { |s| s.reverse }
    TestGrammar.action(:cap) { |s| @capture = s }
    TestGrammar.rule(:foobar) { (foo >= cap) & bar }
    TestGrammar.rule(:barfoo) { (foo >= (rev >> cap)) & bar }
    @grammar = TestGrammar.new
  end

  after do
    Object.__send__(:remove_const, :TestGrammar)
  end

  it "should it call the bypassed parser with the matched string" do
    @grammar.foobar.("foobar")
    @grammar.capture.must_equal "foo"
  end

  it "should combine with other parsers as if the bypass weren't there" do
    head, rest = @grammar.foobar.("foobar")
    head.must_equal "foobar"
  end

  it "should allow the bypass to be extended" do
    @grammar.barfoo.("foobar")
    @grammar.capture.must_equal "oof"
  end
end
