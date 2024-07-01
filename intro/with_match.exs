result = with {:ok, file}   =  File.open("/etc/passwd"),
              content       =  IO.read(file, :eof),
              :ok           =  File.close(file),
              # the `<-` operator makes `with` return the bad value if it doesn't match
              # (in this case `nil`)
              [_, uid, gid] <- Regex.run(~r/^xxx:.*?:(\d+):(\d+)/m, content)
         do
           "Group: #{gid}, User: #{uid}"
         end

IO.puts inspect(result)
