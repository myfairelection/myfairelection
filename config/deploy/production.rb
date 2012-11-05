set :branch, 'production'
role :web, "166.78.0.77", "198.61.213.70", "198.101.255.157", "98.129.169.198", "98.129.169.168", "98.129.169.60" # Your HTTP server, Apache/etc
role :app, "166.78.0.77", "198.61.213.70", "198.101.255.157", "98.129.169.198", "98.129.169.168", "98.129.169.60" # This may be the same as your `Web` server
role :db,  "166.78.0.77", :primary => true # This is where Rails migrations will run
