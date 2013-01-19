require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Parser::Literal do
  def parser
    Chomsky::Parser::Literal.("literal")
  end

  it "returns the match when the input string matches its value" do
    tok, rest = parser.("literally the craziest thing")
    tok.must_equal "literal"
  end

  it "consumes the input it matches" do
    tok, rest = parser.("literally the craziest thing")
    rest.must_equal "ly the craziest thing"
  end

  it "does not match anything else" do
    tok, rest = parser.("something besides 'literal'")
    tok.must_be_nil
  end

  it "does not consume any input when it doesn't match" do
    tok, rest = parser.("something besides 'literal'")
    rest.must_equal "something besides 'literal'"
  end

  it "does not match an empty string" do
    tok, rest = parser.("")
    tok.must_be_nil
  end
end
