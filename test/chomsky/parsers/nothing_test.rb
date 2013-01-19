require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Parser::Nothing do
  def parser
    Chomsky::Parser::Nothing.()
  end

  it "should match an empty string" do
    tok, rest = parser.("")
    tok.must_equal ""
  end

  it "should not consume any input" do
    tok, rest = parser.("")
    rest.must_equal ""
  end

  it "should not match any input" do
    tok, rest = parser.("match this!")
    tok.must_be_nil
  end

  it "should not consume any input" do
    tok, rest = parser.("truncate me!")
    rest.must_equal "truncate me!"
  end
end
