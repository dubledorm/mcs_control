FactoryGirl.define do
  factory :program, class: Program do
    sequence(:database_name) { |n| "database_name#{n}" }
    sequence(:identification_name) { |n| "identification-name#{n}" }
    program_type 'mc'
    instance
  end

  factory :mc_program, parent: :program do
    program_type 'mc'
    after_create do |program|
      program.ports << FactoryGirl.create(:port, port_type: 'http')
    end
  end

  factory :op_program, parent: :program do
    program_type 'op'
    after_create do |program|
      program.ports << FactoryGirl.create(:port, port_type: 'http')
    end
  end

  factory :cli_program, parent: :program do
    program_type 'dcs-cli'
  end

  factory :dev_program, parent: :program do
    program_type 'dcs-dev'
    after_create do |program|
      program.ports << FactoryGirl.create(:port, port_type: 'tcp')
      program.ports << FactoryGirl.create(:port, port_type: 'tcp')
      program.ports << FactoryGirl.create(:port, port_type: 'tcp')
    end
  end

  factory :pf2_program, parent: :program do
    program_type 'pf2'
    after_create do |program|
      program.ports << FactoryGirl.create(:port, port_type: 'tcp')
      program.ports << FactoryGirl.create(:port, port_type: 'tcp')
    end
  end

  factory :dev_program_and_one_port, parent: :program do
    program_type 'dcs-dev'
    after_create do |program|
      program.ports << FactoryGirl.create(:port, port_type: 'tcp')
    end
  end
end
