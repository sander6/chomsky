require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Parser do
  def parser
    Chomsky::Parser.new
  end

  it "should not match anything" do
    tok, rest = parser.("match this!")
    tok.must_be_nil
  end

  it "should not consume any input" do
    tok, rest = parser.("consume me!")
    rest.must_equal "consume me!"
  end

  it "should return itself when cast as a parser generator" do
    p = parser
    p.to_pg.must_be_same_as p
  end
end
