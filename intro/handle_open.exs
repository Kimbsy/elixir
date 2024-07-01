handle_open = fn
  {:ok, file} -> "Read data: #{IO.read(file, :line)}"
  {_, error} -> "Error: #{:file.format_error(error)}"
end

# This file exists
IO.puts handle_open.(File.open("/etc/dictionaries-common/words"))

# This file does not exist
IO.puts handle_open.(File.open("fooooooo"))
