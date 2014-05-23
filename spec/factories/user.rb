FactoryGirl.define do
  factory :user do
    email 'user@example.com'
    password 'foobar'
    admin false
  end
  factory :admin, class: User do
    email 'admin@example.com'
    password 'barfoo'
    admin true
  end
end
