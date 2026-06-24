Setting.find_or_create_by!(key: "voting_open") { |s| s.value = "false" }
Setting.find_or_create_by!(key: "results_public") { |s| s.value = "false" }

puts "Seeds complete. Use admin dashboard to add contestants."
