FactoryGirl.define do
  factory :program, class: Program do
    sequence(:database_name) { |n| "database_name#{n}" }
    program_type 'mc'
    instance
  end
end
