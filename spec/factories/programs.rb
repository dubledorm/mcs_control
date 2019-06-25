FactoryGirl.define do
  factory :program, class: Program do
    sequence(:name) { |n| "name#{n}" }
    program_type 'mc'
    instance
  end
end
