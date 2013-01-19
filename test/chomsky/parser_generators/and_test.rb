require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::And do
  def parser
    Chomsky::ParserGenerator::And.(Chomsky::Parser::Literal.("this "), Chomsky::Parser::Literal.("and that"))
  end

  it "should match the first parser followed by the second parser" do
    tok, rest = parser.("this and that and the other")
    tok.must_equal "this and that"
  end

  it "should consume all the input it matches" do
    tok, rest = parser.("this and that and the other")
    rest.must_equal " and the other"
  end

  it "should not match if the second parser doesn't match" do
    tok, rest = parser.("this means war")
    tok.must_be_nil
  end

  it "should not consume any input if the second parser doesn't match" do
    tok, rest = parser.("this means war")
    rest.must_equal "this means war"
  end
end
