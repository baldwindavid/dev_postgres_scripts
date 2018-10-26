def print(current_version, this_version, text)
  status = if current_version == this_version
    "#{this_version} (current): #{text}"
  else
    "#{this_version}: #{text}"
  end

  puts status
end

def stop_all_versions
  `asdf list postgres`.split.each do |version|
    current_version = `postgres -V`.split(" ").last

    is_started = `[ -f /Users/baldwindavid/.asdf/installs/postgres/#{version}/data/postmaster.pid ] && echo "true"`
    is_started = is_started.chomp! == "true"
    is_current_version = version == current_version

    if is_started
      print(current_version, version, "Stopping.")
      `pg_ctl -D /Users/baldwindavid/.asdf/installs/postgres/#{version}/data stop`
    else
      print(current_version, version, "Not running. Nothing to do.")
    end

  end
end

puts "\n"
puts "Stopping All Postgres Versions"
puts "------------------------------"
stop_all_versions
puts "\n"
