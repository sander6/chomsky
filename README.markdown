# Chomsky - a pure-Ruby parsing expression grammar generator

Chomsky generates parsing expression grammars with a nice pure-ruby DSL, eliminating 
the need for secondary grammar definition files or out-of-band compilation, and 
allowing a grammar's rules to grow dynamically or be manipulated as easy-to-understand
Ruby objects.

## Install

    $ gem install chomsky

Chomsky has no dependencies. It was written for Ruby 1.9.3 and untested on earlier versions.

You can run the tests by doing

    $ ruby test/chomsky_test.rb

Or the more common

    $ rake

## Usage

The two main concepts when working with Chomsky are *rules* and *actions*. Rules define the
patterns in the input string, and actions define what to do when rules are matched.

### Rules

Rules are defined using `rule :name { expression }`. Chomsky provides a nice DSL for most
common parsing constructs.

  * literals : `` `foo` `` matches the literal sequence "foo"
  * regular expressions : `r /pattern/` matches the regular expression pattern (anchored at
      the front of input)
  * concatenation : `foo & bar` matches rule `foo` followed by rule `bar`
  * alternation : `foo | bar` matches either rule `foo` or rule `bar`
  * repetition : many of the familiar regular expression-like repetition constructs are
    reproduced in Chomsky's DSL
    * `foo._?` : matches zero or one occurances of the rule `foo`
    * `foo.+` : matches one or more occurances of the rule `foo`
    * `foo.*` : matches zero or more occurances of the rule `foo`
    * `foo[n]` : matches `n` or more occurances of rule `foo`
    * `foo[n,m]` : matches between `n` and `m` occurances of rule `foo`
  * skipping : `foo > bar` matches rule `foo` followed by `bar`, but ignores `bar`'s output;
    similarly `foo < bar` is equal to `foo & bar` yet discarding `foo`'s output.
  * composition : `foo >> bar` matches if rule `foo` matches, and rule `bar` matches the
    output of `foo`
  * side effects : `foo >= bar` matches rule `foo` and sends the matching portion to `bar`, but
    ultimately returns `foo`'s return value. The `>=` construct is mostly used to combine rules
    and actions, to perform some side effect whenever a rule matches but not otherwise interfere
    with the parsing pipeline.

Some common rules have built-in methods already.

  * `_` : matches any single character
  * `___` : matches one or more whitespaces (i.e. `/\s/`)
  * `___?` : matches zero or more whitespaces
  * `eos` : matches EOS (i.e. no more input)

Defining a rule defines a method on the grammar with the same name that returns a `Rule` object
as defined by the block. Therefore, you can call the rule as a method to use it inside other rules.

```ruby
rule :foo { `foo` }
rule :bar { foo & `bar` }
```

Because everything's enclosed in blocks, you can refer to rules before defining them, and you can
even define recursive rules.

```ruby
rule :numlist { empty | (number & `:` & numlist) }
rule :number { r /0|-?[1-9]*[0-9]/ }
rule :empty { `[]` }
```

One gotcha when working with rules on their own: if you define a rule named `foo`, then calling
`@grammar.foo` will return the rule object itself. If you want to run the rule against an input
string, you must do `@grammar.foo.call(string)` instead of `@grammar.foo(string)`.

### Actions

Actions are defined similarly using `action :name { |string| expression }`. Actions are just code
blocks that run given the output of the previous parser in the pipeline. Depending on how they're
composed with the parsers around them, actions can be used to perform a number of different tasks.

Most commonly, actions are used with the `Bypass` parser generator to call an action with the
matched result of another parser.

```ruby
rule :foo { `foo` }
action :bar { |s| @string = s }
rule :foobar { foo >= bar }
```

Using the `Compose` generator, you can add string manipulation filters. In the following example,
the rule `foo` matches the literal, lowercase string `"foo"`, but using the `bar` filter, the parsed
result would be returned as `"FOO"`.

```ruby
rule :foo { `foo` }
action :bar { |s| s.upcase }
rule :foobar { foo >> bar }
```

Also useful is using actions with the `Or` parser generator to do something if a rule doesn't
match.

```ruby
rule :foo { `foo` }
action :explode { |s| raise "KABOOM!" }
rule :must_be_foo { foo | explode }
```

Like with rules, defining an action defines a method on the grammar of the same name that returns
an `Action` object. To call an action in isolation, do `@grammar.<action-name>.call(string)`.

### Captures and Backreferences

Two parser generators of special note are the `Capture` and `Backreference` generators. These
can be used when a particular pattern can only be known while parsing so as to be matched
later, such as in a heredoc. Use the `capture` (or `cap`) method to assign a name to a matched
string, then use the `reference` (or `ref`) method to return a parser that matches the literal
captured string.

```ruby
rule :heredoc { (r(/[A-Z]+/) >= cap(:delim)) & _.* & ref(:delim) }
```

Captures and backreferences are local to the rule that uses them, so nested captures will be
properly scoped.

## Example

Below is an example grammar for parsing JSON to illustrate rules and actions and how they work
together.

```ruby
require 'chomsky'

class JSON < Chomsky::Grammar

  # Rules
  rule :value { ___? < (array | object | primitive) > ___? }

  rule :array { (`[` >= push_array) & (element & (`,` & element).*)._? & `]` }

  rule :element { value >= pop_onto_array }

  rule :object { (`{` >= push_object) & (pair & (`,` & pair).*)._? & `}` }

  rule :pair { ((___? < string > ___?) & `:` & value) >= pop_onto_object }
  
  rule :primitive { string | number | boolean | null }

  rule :number { integer | float }

  rule :integer { r(%r{0|-?[1-9][0-9]*(?:[eE][-+]?[1-9][0-9]*)?}) >= push_int }

  rule :float { r(%r{(?:0|-?[1-9][0-9]*)\.[0-9]+(?:[eE][-+]?[1-9][0-9]*)?}) >= push_float }

  rule :string { r(%r{"(?:[^"\\]|\\.)*"}) >= push_string }

  rule :boolean { (`true` >= push_true) | (`false` >= push_false) }

  rule :null { `null` >= push_null }

  # Actions
  
  action :push_array { |s| @stack.push([]) }

  action :push_object { |s| @stack.push({}) }

  action :push_int { |s| @stack.push(s.to_i) }

  action :push_float { |s| @stack.push(s.to_f) }

  action :push_string { |s| @stack.push(s[1..-2]) }

  action :push_true { |s| @stack.push(true) }

  action :push_false { |s| @stack.push(false) }

  action :push_null { |s| @stack.push(nil) }

  action :pop_onto_array { |s| val, ary = @stack.pop(2); @stack.push(ary << val) }

  action :pop_onto_object { |s| val, key, obj = @stack.pop(3); obj[key] = val; @stack.push(obj) }

  action :error { |s| raise "Invalid JSON" }

  def call string
    @stack.clear
    head, rest = (value | error).(string)
    head ? @stack.pop : nil
  end

  def initialize
    @stack = []
  end
end
```
