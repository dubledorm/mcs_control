FactoryGirl.define do

  factory :admin_user, class: AdminUser do |au|
    sequence(:email) {|n| "email#{n}@mail.ru" }
    au.password '12345678'
  end
end
