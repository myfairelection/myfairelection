set :branch, 'production'
role :web, "198.61.213.70", "198.101.255.157" # Your HTTP server, Apache/etc
role :app, "198.61.213.70", "198.101.255.157" # This may be the same as your `Web` server
role :db,  "198.61.213.70", :primary => true # This is where Rails migrations will run
