require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Rule do
  before do
    TestGrammar = Class.new(Chomsky::Grammar)
    TestGrammar.rule(:foo) { `foo` }
    @grammar = TestGrammar.new
  end

  after do
    Object.__send__(:remove_const, :TestGrammar)
  end

  describe "when the input string doesn't match the enclosed rule" do
    it "should not match" do
      tok, rest = @grammar.foo.("barfoo")
      tok.must_be_nil
    end

    it "should not consume any input" do
      tok, rest = @grammar.foo.("barfoo")
      rest.must_equal "barfoo"
    end
  end

  describe "when the input string matches the enclosed rule" do
    it "should match" do
      tok, rest = @grammar.foo.("foobar")
      tok.must_equal "foo"
    end

    it "should consume the input it matches" do
      tok, rest = @grammar.foo.("foobar")
      rest.must_equal "bar"
    end
  end
end
