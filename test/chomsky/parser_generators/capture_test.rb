require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::ParserGenerator::Capture do
  before do
    @capture = Chomsky::ParserGenerator::Capture.new
  end

  it "should match any input given" do
    head, rest = @capture.("foo")
    head.must_equal "foo"
  end

  it "should consume all input" do
    head, rest = @capture.("foo")
    rest.must_equal ""
  end

  describe "using the captured parser" do
    before do
      @parser = Chomsky::Parser::Anything.(3) >> @capture
    end

    it "should save the input given as a literal parser" do
      @capture.parser.must_be_nil
      @parser.("foobar")
      @capture.parser.must_be_instance_of Chomsky::Parser::Literal
    end

    it "should have its captured parser match the literal input it was created with" do
      @parser.("foobar")
      head, rest = @capture.parser.("foobar")
      head.must_equal "foo"
      rest.must_equal "bar"
    end
  end

  describe "used in a grammar" do
    before do
      TestGrammar = Class.new(Chomsky::Grammar)
      TestGrammar.rule(:heredoc) { (r(%r{[A-Z]+}) >> cap(:delim)) & r(%r{[a-z\n]+}) & ref(:delim) }
      @grammar = TestGrammar.new
    end

    after do
      Object.__send__(:remove_const, :TestGrammar)
    end

    describe "if the backreference matches" do
      before do
        @string = "END\nfoo\nbar\nbaz\nquux\nEND"
      end

      it "should match" do
        head, rest = @grammar.heredoc.(@string)
        head.must_equal @string
      end

      it "should consume" do
        head, rest = @grammar.heredoc.(@string)
        rest.must_equal ""
      end
    end

    describe "if the backreference doesn't match" do
      before do
        @string = "END\nfoo\nbar\nbaz\nquux\nEOS"
      end

      it "should not match" do
        head, rest = @grammar.heredoc.(@string)
        head.must_be_nil
      end

      it "should not consume" do
        head, rest = @grammar.heredoc.(@string)
        rest.must_equal @string
      end
    end
  end
end
