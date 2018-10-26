def print(current_version, this_version, text)
  status = if current_version == this_version
    "#{this_version} (current): #{text}"
  else
    "#{this_version}: #{text}"
  end

  puts status
end

def print_versions
  `asdf list postgres`.split.each do |version|
    current_version = `postgres -V`.split(" ").last

    is_started = `[ -f /Users/baldwindavid/.asdf/installs/postgres/#{version}/data/postmaster.pid ] && echo "true"`

    if is_started.chomp! == "true"
      print(current_version, version, "Running.")
      postmaster_path = "/Users/baldwindavid/.asdf/installs/postgres/#{version}/data/postmaster.pid"
      puts "Contents of " + postmaster_path
      puts `cat #{postmaster_path}`
    elsif version == current_version
      print(current_version, version, "Not running. Start with `pgstart[2,3]`.")
    else
      print(current_version, version, "Not running.")
    end

    puts "\n"
  end
end

puts "\n"
puts "Postgres Version Status"
puts "-----------------------"
print_versions
puts "\n"
