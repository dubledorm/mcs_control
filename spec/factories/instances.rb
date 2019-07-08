FactoryGirl.define do
  factory :instance, class: Instance do
    sequence(:name) { |n| "name#{n}" }
    sequence(:db_user_name) { |n| "db_user_name_#{n}" }
    description 'Описание инстанса'
    owner_name 'владелец инстанса'
  end
end
