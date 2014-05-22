class StateMapData < ActiveRecord::Base
  attr_accessible :name, :rating, :wait_time, :n

  STATES = ['AL', 'AK', 'AZ', 'AR', 'CA',
            'CO', 'CT', 'DE', 'DC', 'FL',
            'GA', 'HI', 'ID', 'IL', 'IN',
            'IA', 'KS', 'KY', 'LA', 'ME',
            'MD', 'MA', 'MI', 'MN', 'MS',
            'MO', 'MT', 'NE', 'NV', 'NH',
            'NJ', 'NM', 'NY', 'NC', 'ND',
            'OH', 'OK', 'OR', 'PA', 'RI',
            'SC', 'SD', 'TN', 'TX', 'UT',
            'VT', 'VA', 'WA', 'WV', 'WI', 'WY']

  def self.update
    self.transaction do
      puts 'transaction started'
      connection.execute('delete from state_map_data;')
      puts 'rows deleted'
      STATES.each do |state|
        connection.execute("insert into state_map_data
          select '#{state}', avg(wait_time) as wait_time, avg(rating) as
          rating, count(*) as n from
            (select r.rating, r.wait_time, pl.state from reviews r,
                                                         polling_locations pl
              where pl.id = r.polling_location_id
              and pl.state = '#{state}'
              order by r.voted_day desc,
                                   r.voted_time desc,
                                   r.created_at desc limit 10)
          as top_reviews;")
      end
      puts 'rows updated'
    end
    puts 'transaction complete'
  end
end

# insert into state_map_data
# select polling_locations.state as name, avg(rating) as rating,
# avg(wait_time) as wait_time,count(*) as n
#   from reviews, polling_locations 
#   where reviews.polling_location_id = polling_locations.id
#   group by polling_locations.state;

# select reviews.*, polling_locations.state
#   from reviews, polling_locations 
#   where reviews.polling_location_id = polling_locations.id
#   order by polling_locations.state, reviews.voted_day, reviews.voted_time
#   limit 2;

# select state, avg(rating) as rating,
#   avg(wait_time) as wait_time, count(*) as n from
#    (select r.rating, r.wait_time, pl.state from reviews r,
#               polling_locations pl
#     where pl.id = r.polling_location_id
#         and pl.state = "CA"
#     order by r.voted_day desc, r.voted_time desc,
#              r.created_at desc limit 10) as top_reviews;
