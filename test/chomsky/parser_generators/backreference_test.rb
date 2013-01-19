require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Backreference do
  before do
    @capture = Chomsky::ParserGenerator::Capture.new
    @backref = Chomsky::ParserGenerator::Backreference.(@capture)
  end

  describe "when the enclosed capture has not captured anything" do
    before do
      @capture.parser.must_be_nil
    end

    it "should not match any input" do
      head, rest = @backref.("foobar")
      head.must_be_nil
    end

    it "should not consume any input" do
      head, rest = @backref.("foobar")
      rest.must_equal "foobar"
    end
  end

  describe "when the enclosed capture has captured something" do
    before do
      @capture.("foo")
    end

    describe "and the enclosed capture's parser doesn't match" do
      it "should not match" do
        head, rest = @backref.("barfoo")
        head.must_be_nil
      end

      it "should not consume input" do
        head, rest = @backref.("barfoo")
        rest.must_equal "barfoo"
      end
    end

    describe "and the enclosed capture's parser matches" do
      it "should match" do
        head, rest = @backref.("foobar")
        head.must_equal "foo"
      end

      it "should consume input" do
        head, rest = @backref.("foobar")
        rest.must_equal "bar"
      end
    end
  end
end
