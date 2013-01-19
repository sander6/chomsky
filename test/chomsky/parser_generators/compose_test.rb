require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Compose do
  def parser
    Chomsky::ParserGenerator::Compose.(Chomsky::Parser::Regexp.(%r{...bar}), Chomsky::Parser::Literal.("foo"))
  end

  it "should not match if the first parser doesn't match" do
    tok, rest = parser.("flob")
    tok.must_be_nil
  end

  it "should not consume any input if the first parser doesn't match" do
    tok, rest = parser.("flob")
    rest.must_equal "flob"
  end

  it "should match if the second parser matches the output of the first" do
    tok, rest = parser.("foobar!")
    tok.must_equal "foo"
  end

  it "should consume all input it matches" do
    tok, rest = parser.("foobar!")
    rest.must_equal "!"
  end

  it "should not match if the second parser doesn't match the output of the first" do
    tok, rest = parser.("hoobarstank!")
    tok.must_be_nil
  end

  it "should not consume any input if the second parser doesn't match the output of the first" do
    tok, rest = parser.("hoobarstank!")
    rest.must_equal "hoobarstank!"
  end
end
