require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Or do
  def parser
    Chomsky::ParserGenerator::Or.(Chomsky::Parser::Literal.("this"), Chomsky::Parser::Literal.("that"))
  end

  it "matches when its first parser matches" do
    tok, rest = parser.("this ain't over")
    tok.must_equal "this"
  end

  it "matches when its second parser matches" do
    tok, rest = parser.("that dog won't hunt")
    tok.must_equal "that"
  end

  it "consumes the input it matches" do
    tok, rest = parser.("this ain't over")
    rest.must_equal " ain't over"
  end

  it "doesn't match if both its parsers don't match" do
    tok, rest = parser.("thar? that's not a word")
    tok.must_be_nil
  end

  it "doesn't consume any input if neither of its parsers match" do
    tok, rest = parser.("thar? that's not a word")
    rest.must_equal "thar? that's not a word"
  end
end
