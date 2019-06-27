FactoryGirl.define do
  factory :instance, class: Instance do
    sequence(:name) { |n| "name-#{n}" }
    description 'Описание инстанса'
    owner_name 'владелец инстанса'
  end
end
