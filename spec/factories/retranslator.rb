FactoryGirl.define do
  factory :retranslator, class: Retranslator do
    sequence(:port_from) { |n| n }
    sequence(:port_to) { |n| n }
  end
end