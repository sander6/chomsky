require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Perhaps do
  def parser
    Chomsky::ParserGenerator::Perhaps.(Chomsky::Parser::Literal.("foo"))
  end

  it "should match when the input string matches its value" do
    tok, rest = parser.("foofernoodles!")
    tok.must_equal "foo"
  end

  it "should consume the input it matches" do
    tok, rest = parser.("foofernoodles!")
    rest.must_equal "fernoodles!"
  end

  it "should return an empty string if the input doesn't match its value" do
    tok, rest = parser.("barboblargle")
    tok.must_equal ""
  end

  it "should not consume any input when it doesn't match" do
    tok, rest = parser.("barboblargle")
    rest.must_equal "barboblargle"
  end
end
