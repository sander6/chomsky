require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Peek do
  def parser
    Chomsky::ParserGenerator::Peek.(Chomsky::Parser::Literal.("this"))
  end

  it "should match if the supplied parser matches" do
    tok, rest = parser.("this and that")
    tok.wont_be_nil
  end

  it "should not consume the input it matches" do
    tok, rest = parser.("this and that")
    rest.must_equal "this and that"
  end

  it "should not match if the supplied parser doesn't match" do
    tok, rest = parser.("that's incredible!")
    tok.must_be_nil
  end

  it "should not consume any input if the supplied parser doesn't match" do
    tok, rest = parser.("that's incredible!")
    rest.must_equal "that's incredible!"
  end
end
