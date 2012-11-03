class StateMapData < ActiveRecord::Base
  attr_accessible :name, :rating, :wait_time, :n

  def self.update
    self.transaction do
      puts 'transaction started'
      connection.execute('delete from state_map_data;')
      puts 'rows deleted'
      connection.execute('insert into state_map_data 
        select polling_locations.state as name, 
               avg(rating) as rating,
               avg(wait_time) as wait_time,
               count(*) as n 
          from reviews, polling_locations 
          where reviews.polling_location_id = polling_locations.id 
          group by polling_locations.state;')
      puts 'rows updated'
    end
    puts 'transaction complete'
  end
end

# insert into state_map_data
# select polling_locations.state as name, avg(rating) as rating ,avg(wait_time) as wait_time,count(*) as n
#   from reviews, polling_locations 
#   where reviews.polling_location_id = polling_locations.id group by polling_locations.state;


# select reviews.*, polling_locations.state
#   from reviews, polling_locations 
#   where reviews.polling_location_id = polling_locations.id
#   order by polling_locations.state, reviews.voted_day, reviews.voted_time
#   limit 2;
