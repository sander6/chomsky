require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path(File.join(*%w{. .. .. .. lib}), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chomsky'

describe Chomsky::Grammar do
  before do
    TestGrammar = Class.new(Chomsky::Grammar)
  end

  after do
    Object.__send__(:remove_const, :TestGrammar)
  end

  def grammar
    @grammar ||= TestGrammar.new
  end

  describe "defining rules" do
    it "should define a method with the same name as the rule" do
      TestGrammar.rule(:foo) { `foo` }
      grammar.must_respond_to :foo
    end

    it "should return a rule object when that method is called" do
      TestGrammar.rule(:foo) { `foo` }
      rule = grammar.foo
      rule.must_be_instance_of Chomsky::Rule
    end
  end

  describe "defining actions" do
    it "should define a method with the same name as the action" do
      TestGrammar.action(:bar) { |s| "bar!" }
      grammar.must_respond_to :bar
    end

    it "should return an action object when that method is called" do
      TestGrammar.action(:bar) { |s| "bar!" }
      action = grammar.bar
      action.must_be_instance_of Chomsky::Action
    end
  end
end
