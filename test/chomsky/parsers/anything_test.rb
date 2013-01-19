require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Parser::Anything do
  def parser
    Chomsky::Parser::Anything.new
  end

  def parser_with_length len
    Chomsky::Parser::Anything.new(len)
  end

  it "should default to length 1" do
    parser.length.must_equal 1
  end

  it "should match any character up to its length" do
    tok, rest = parser_with_length(3).("hooray!")
    tok.must_equal "hoo"
  end

  it "should consume the input it matches" do
    tok, rest = parser_with_length(3).("hooray!")
    rest.must_equal "ray!"
  end

  it "should not match an empty string" do
    tok, rest = parser.("")
    tok.must_be_nil
  end

  it "should not match a string shorter than the length" do
    tok, rest = parser_with_length(4).("foo")
    tok.must_be_nil
  end
end
