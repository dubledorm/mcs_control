FactoryGirl.define do
  factory :program, class: Program do
    sequence(:database_name) { |n| "database_name#{n}" }
    sequence(:identification_name) { |n| "identification-name#{n}" }
    program_type 'mc'
    instance
  end
end
