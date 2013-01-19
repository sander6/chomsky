require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Some do
  def parser
    Chomsky::ParserGenerator::Some.(Chomsky::Parser::Literal.("a"))
  end

  it "should match one instance of the supplied parser" do
    tok, rest = parser.("abcdefg")
    tok.must_equal "a"
  end

  it "should match more than one instance of the supplised parser" do
    tok, rest = parser.("aaaaabcd")
    tok.must_equal "aaaaa"
  end

  it "should consume all the input it matches" do
    tok, rest = parser.("aaaaabcd")
    rest.must_equal "bcd"
  end

  it "should not match if the supplied parser doesn't match" do
    tok, rest = parser.("bbbbb")
    tok.must_be_nil
  end

  it "should not consume any input if the supplied parser doesn't match" do
    tok, rest = parser.("bbbbb")
    rest.must_equal "bbbbb"
  end
end
