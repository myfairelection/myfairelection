# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    voted_day "10-27"
    voted_time "11:22"
    wait_time 10
    able_to_vote false
    rating 1
    comments "MyText"
  end
end
