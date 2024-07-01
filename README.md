# Elixir

Working through "Programming Elixir >= 1.6".

## setup

Install Elixir (and Erlang) with [`asdf`](https://asdf-vm.com/guide/getting-started.html).

Install [Erlang](https://github.com/asdf-vm/asdf-erlang) and [Elixir](https://github.com/asdf-vm/asdf-elixir) plugins.

Install the latest versions of each:

``` Bash
asdf install erlang latest
asdf install elixir latest
```

Set global versions:

``` Bash
asdf global erlang latest
asdf global elixir latest
```

## execution

Run a repl with `iex`.

Compile and run a script file with `elixir foo.exs` (`.exs` for scripts, `.ex` for compiling to binaries).

Function arity denoted with `foo/n`.

Get general help with the `h/0` function.

Get help for module with `h/1`.

Inspect a value with the `i/1` helper function.

Get typeinfo of a function with `t/1`.

## basics

``` Elixir
if (foo == bar) do
  do_stuff
end
```

Everything is truthy except `false` and `nil` (in most contexts).

`==` is value equality, `===` is strict (where `1` and `1.0` are not equal).

`not`, `and`, an `or` expect booleans, `!`, `&&`, `||` will work on any value.

Can omit function call parens:

``` Elixir
foo "bar"
foo("bar")

foo "bar", "baz"
foo("bar", "baz")
```

Printing to stdout:

``` Elixir
IO.puts "Hello, World!"
```

Concat strings with `<>`.

Interpolate expressions into strings:

``` Elixir
a = 1
b = 2

"total: #{a + b}"
# => "total: 3"
```

`in` check for membership in Enums like Strings, Lists and Maps. Maps should check {key, value} tuples.

## data types

- Atoms (Clojure keyword equivalent) `:foo`
- Tuples `{1, "foo", :bar}`
- Lists `[1, 2, 3]` can be constructed with a `[head | tail]` e.g. `[0 | [1, 2, 3]]`
- Maps `%{1 => 2, 3 => 4}` can use atoms as keys for nicer syntax `%{foo: 1, bar: 2}`
  - can mix both if atoms come last??? `%{1 => 2, foo: 1, bar: 2}`
- Ranges `1..10` can specify optional step size with `1..10//2`
- Regex `~r{\d+}` (braces can be swapped for any desired delimiter to avoid escaping)

## pattern matching

``` Elixir
a = 1
1 = a

2 = a # throws MatchError

[a, b, c] = [1, 2, 3]

[a, b] = [1, 2, 3] # throws MatchError

[a, b, b] = [1, 2, 2]
[a, b, b] = [1, 2, 3] # throws MatchError

[a, _, _] = [1, 2, 3] # _ discards values

# works fo tuples too
{a, b} = {1, 2}

# common for a function to return a tuple of {:ok, result}
{status, file} = File.open("foo.exs")
# => {:ok, #PID<0.39.0>}

# you can use pattern atching toensure the file existed
{:ok, file} = File.open("foo.exs")
# ^ will MatcError if file doesn't exist since won't return :ok

# can `pin` values while pattern matching to refer to the current value
a = 1
a = 2
^a = 1 # throws MatchError

# pinning feels a little like unquoting inside pattern allowing you to use the value of a variable:
a = 1
[^a, 2, c] = [1, 2, 3]   # c is 3
[^a, 2, c] = [0, 2, 3]   # throws MatchError
[a, 2, c]  = [0, 2, 3]   # c is 3, a is 0 (without pinning we bind a)
```

## lists

``` Elixir
# concatenation
[1, 2, 3] ++ [4, 5, 6]

# difference
[1, 2, 3, 4] -- [2, 4]
# => [1, 3]

[1, 1, 1] -- [1, 1]
# => [1]

# membership
:a in [:a, :b, :c]
```

Can create keyword lists:

``` Elixir
[name: "Dave", city: "Dallas", likes: "programming"]
```

Which ends up as a list of two-value tuples.

We can omit the square brackets of a keyword list if it's the last arg in a function (useful for opts):

``` Elixir
DB.save record, [{:use_transaction, true}, :logging, "HIGH"}]

DB.save record, use_transaction: true, logging: "HIGH"
```
> We can omit the brackets if a keyword list appears in any context where a list of values is expected.

``` Elixir
[1, fred: 1, dave: 2]
# => [1, {:fred, 1}, {:dave, 2}]

{1, fred: 1, dave: 2}
# => {1, [fred: 1, dave: 2]}
```

## maps

Basic syntax `%{"foo" => 1, "bar" => 2}`, but can use shortcut syntax if we use atoms as keys (like keyword lists). `%{foo: 1, bar: 2}`.

Maps need unique keys (unlike keyword lists):

``` Elixir
%{foo: 1, foo: 2} # emits a warning

# => %{foo: 2}
# It seems like the last value wins (have tried for many)
```

Can access values using square brackets:

``` Elixir
states = %{"AL" => "Alabama", "WI" => "Wisconsin"}

states["AL"]
# => "Alabama"

states["foo"]
# => nil
```

If using atoms keys can use dot notation:

``` Elixir
colors = {:red => 0xff0000, :green => 0x00ff00, :blue => 0x0000ff}

colors.red
# => 16711680

colors.foo # => throws KeyError
```

## dates

Built-in dates and times (everything is ISO8601), can be constructed `{:ok, d1} = Date.new(2024, 05, 22)` or created inline using `sigils` (syntax for literals?) `~D[...]` and `~T[...]`. Can also do a Date range quite easily.

``` Elixir
{:ok, d1} = Date.new(2024, 06, 30)
# => {:ok, ~D[2024-06-30]}

Date.day_of_week(d1)
# => 7

Date.add(d1, 10)
# => ~D[2024-07-10]

inspect d1, structs: false
# => "%{calendar: Calendar.ISO, month: 6, __struct__: Date, day: 30, year: 2024}"
#       ^ implies it'll work like a Map with these atom keys, so we should be
#         able to use dot-syntax to get values

d1.month     # => 6
d1.day       # = 30
d1.calendar  # => Calendar.ISO

d2 = ~D[2025-06-30]

r = Date.range(d1, d2)
# => Date.range(~D[2024-06-30], ~D[2025-06-30])

Enum.count(r)
# => 366

~D[2025-05-15] in r
# => true
```
Very similar for times (but no ranges):

``` Elixir
{:ok, t1} = Time.new(12, 06, 10)
# => {:ok, ~T[12:06:10]}

inspect t1, structs: false
# => "%{microsecond: {0, 0},
#       second: 10,
#       calendar: Calendar.ISO,
#       __struct__: Time,
#       minute: 6,
#       hour: 12}"

t1.second   # => 10

Time.add(t1, 100)
# => ~T[12:07:50]

Time.add(t1, 100, :millisecond)
# => ~T[12:06:10.100]
```

## anonymous functions

Simple lambdas are unsurprising, but you need to use a dot syntax to call them and must include argument parens.

> Personal note. This feels (right now, admittedly early on) really
> clunky, especially compared to Clojure. There is just a tiny bit
> more overhead to using higher order functions. You write your fn,
> name it, and then type `foo 42` and get a CompileError because you
> didn't do `foo.(42)`. It means you can't easily replace the use of a
> named function with an anonymous one. It feels a little like
> anonymous functions are _not_ actually first class citizens of the
> language, which feels odd for a functional language.

``` Elixir
sum = fn (a, b) -> a + b end

sum.(2, 3)
# => 5

# can omit parameter parens
product = fn a, b -> a * b end

product.(4, 5)
# => 20

# nonary function
greet = fn -> IO.puts("hi") end

greet.()
# => hi
# => :ok
```

You can pattern match in the formal parameters:

``` Elixir
first = fn [x | _xs] -> x end

first.([33, 44, 55])
# => 33

swap = fn {a, b} -> {b, a} end

swap.({:foo, :bar})
# => {:bar, :foo}
```

You can supply multiple implementations allowing you to modify behaviour. They must be the same arity, but can use pattern matching.

``` Elixir
handle_open = fn
  {:ok, file} -> "Read data: #{IO.read(file, :line)}"
  {_, error} -> "Error: #{:file.format_error(error)}"   # :file is Erlang module
end

handle_open.(File.open("fooooooo"))                     # File is Elixir module
# => "Error: no such file or directory"

handle_open.(File.open("/etc/dictionaries-common/words"))
# => "Read data: A\n"
```

``` Elixir
# outer and inner functions taking args
prefix = fn pre -> (fn s -> pre <> " " <> s end) end
pre_foo = prefix.("foo")
pre_foo.("bar")
# => "foo bar"

# passing function as an arg
apply = fn (fun, value) -> fun.(value) end
times_two = fn n -> n * 2 end
apply.(times_two, 42)
# => 84

# using built-in map function
list = [1, 2, 3, 4]
Enum.map(list, fn n -> n * 2 end)
# => [2, 4, 6, 8]
```

We can pin values of function paramters like we did with pattern matching, see `intro/pin.exs`.

We can write small lambdas using the `&` syntax:

``` Elixir
inc = &(&1 + 1)
# => #Function<42.39164016/1 in :erl_eval.expr/6>

inc.(5)
# => 6

square = &(&1 * &1)
# => #Function<42.39164016/1 in :erl_eval.expr/6>

square.(99)
# => 9801

speak = &(IO.puts &1)
# => &IO.puts/1
# ^ Elixir is being smart and is just using the IO.puts/1 function.
# This only works if the ody is just a call to the fn and the args 
# are in the right order.

# however we still need to use the dot syntax for calling it
speak.("foo")
# => foo
# => :ok
```

Because `{}` and `[]` are operators in Elixir, we can turn list and tuple literals into functions with `&`. Effectively this lets us omit the `()` that would usually wrap the lambda.

``` Elixir
divrem = &{div(&1, &2), rem(&1, &2)}
divrem.(13, 3)
# => {4, 1}
```

This also works for strings and string-like literals:

``` Elixir
s = &"bacon and #{&1}"
s.("eggs")
# => "bacon and eggs"

match_end = &~r/.*#{&1}$/
# using some funky regex matching operator?
"cat" =~ match_end.("t")   # => true
"cat" =~ match_end.("l")   # => false
```

We can use the `&` function capture operator to wrap a names function f specified arity inside a lambda that will call it.

> Why? can we not just pass them to things by name? It seems not :/

``` Elixir
l = &length/1
l.([1, 2, 3]) # => 3

Enum.map([[1], [2, 2], [3, 3, 3], []], &length/1)
# => [1, 2, 3, 0]

Enum.map [1, 2, 3, 4], &(&1 + 2)
# => [3, 4, 5, 6]

Enum.map [1, 2, 3, 4], &IO.inspect/1
# => 1
# => 2
# => 3
# => 4
# => [1, 2, 3, 4]
```
