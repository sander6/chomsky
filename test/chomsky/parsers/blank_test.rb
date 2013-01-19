require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Parser::Blank do
  def parser
    Chomsky::Parser::Blank.new
  end

  it "should match whitespace" do
    tok, rest = parser.("     spaces!")
    tok.must_equal "     "
  end

  it "should consume any leading whitespace input" do
    tok, rest = parser.("     spaces!")
    rest.must_equal "spaces!"
  end

  it "should not match a non-blank input" do
    tok, rest = parser.("not blank!")
    tok.must_be_nil
  end

  it "should not match an empty string" do
    tok, rest = parser.("")
    tok.must_be_nil
  end

  it "should not consume anything if the input is non-blank" do
    tok, rest = parser.("not blank!")
    rest.must_equal "not blank!"
  end
end
