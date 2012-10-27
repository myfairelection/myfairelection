# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    voted_at "2012-10-27 11:22:38"
    wait_time 1
    able_to_vote false
    rating 1
    comments "MyText"
    polling_location_id 1
    user_id 1
  end
end
