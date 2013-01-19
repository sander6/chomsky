require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Parser::Regexp do
  def parser
    Chomsky::Parser::Regexp.new(%r{a.b.c})
  end

  it "should match input that matches the regexp" do
    tok, rest = parser.("abbacadaba!")
    tok.must_equal "abbac"
  end

  it "should consume the input it matches" do
    tok, rest = parser.("abbacadaba!")
    rest.must_equal "adaba!"
  end

  it "should not match input that doesn't match the regexp" do
    tok, rest = parser.("no match")
    tok.must_be_nil
  end

  it "should not consume anything if the input doesn't match the regexp" do
    tok, rest = parser.("no match")
    rest.must_equal "no match"
  end

  it "should not match an empty string" do
    tok, rest = parser.("")
    tok.must_be_nil
  end
end
