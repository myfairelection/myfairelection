set :branch, 'staging'
role :web, "198.101.255.80"# Your HTTP server, Apache/etc
role :app, "198.101.255.80" # This may be the same as your `Web` server
role :db,  "198.101.255.80", :primary => true # This is where Rails migrations will run
