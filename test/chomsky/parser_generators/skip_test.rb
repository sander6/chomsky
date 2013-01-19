require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Skip do
  def parser
    Chomsky::ParserGenerator::Skip.(Chomsky::Parser::Literal.("junk"))
  end

  it "should not match a string that doesn't equal its value" do
    tok, rest = parser.("this is not junk")
    tok.must_be_nil
  end

  it "should not consume any input when the string doesn't match its value" do
    tok, rest = parser.("this is not junk")
    rest.must_equal "this is not junk"
  end

  it "should return an empty string when it matches its input" do
    tok, rest = parser.("junk to be ignored")
    tok.must_equal ""
  end

  it "should consume the input it matches" do
    tok, rest = parser.("junk to be ignored")
    rest.must_equal " to be ignored"
  end
end
