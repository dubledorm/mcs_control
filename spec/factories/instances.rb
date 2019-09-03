FactoryGirl.define do
  factory :instance, class: Instance do
    sequence(:name) { |n| "name#{n}" }
    sequence(:db_user_name) { |n| "db_user_name_#{n}" }
    description 'Описание инстанса'
    owner_name 'владелец инстанса'
  end

  factory :full_instance, parent: :instance do
    after_create do |instance|
      instance.programs << FactoryGirl.create(:mc_program)
      instance.programs << FactoryGirl.create(:op_program)
      instance.programs << FactoryGirl.create(:cli_program)
      instance.programs << FactoryGirl.create(:dev_program)
    end
  end
end
