FactoryGirl.define do
  factory :stored_file, class: StoredFile do
    sequence(:filename) { |n| "filename#{n}" }
    description 'Описание инстанса'
    content_type 'backup'
    state 'exists'
    admin_user
    program
  end
end
