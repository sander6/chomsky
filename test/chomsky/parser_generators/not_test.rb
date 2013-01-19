require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Not do
  def parser
    Chomsky::ParserGenerator::Not.(Chomsky::Parser::Literal.("this"))
  end

  it "should match input that does not match the supplied parser" do
    tok, rest = parser.("that and this")
    tok.wont_be_nil
  end

  it "should not consume any input if it matches" do
    tok, rest = parser.("that and this")
    rest.must_equal "that and this"
  end

  it "should not match input matches the supplied parser" do
    tok, rest = parser.("this means war")
    tok.must_be_nil
  end

  it "should not consume any input if the second parser matches" do
    tok, rest = parser.("this means war")
    rest.must_equal "this means war"
  end
end
