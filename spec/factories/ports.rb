FactoryGirl.define do
  factory :port, class: Port do
    sequence(:number) { |n| n }
    port_type 'http'
    program
  end
end
