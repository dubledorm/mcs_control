FactoryGirl.define do
  factory :port, class: Port do
    sequence(:number) { |n| n }
    instance
  end
end
