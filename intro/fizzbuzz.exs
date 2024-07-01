fb = fn
  (0, 0, _c) -> "FizzBuzz"
  (0, _b, _c) -> "Fizz"
  (_a, 0, _c) -> "Buzz"
  (_a, _b, c) -> c
end

fizzbuzz = fn
  n -> fb.(rem(n, 3), rem(n, 5), n)
end

IO.puts fizzbuzz.(10)
IO.puts fizzbuzz.(11)
IO.puts fizzbuzz.(12)
IO.puts fizzbuzz.(13)
IO.puts fizzbuzz.(14)
IO.puts fizzbuzz.(15)
IO.puts fizzbuzz.(16)
