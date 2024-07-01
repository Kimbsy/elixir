content = "Now is the time"

lp = with {:ok, file}   = File.open("/etc/passwd"),
          content       = IO.read(file, :eof),    # this `content` is local to the `with`
          :ok           = File.close(file),
          [_, uid, gid] = Regex.run(~r/^lp:.*?:(\d+):(\d+)/m, content)
     do
       "Group: #{gid}, User: #{uid}"
     end

IO.puts lp
IO.puts content     
