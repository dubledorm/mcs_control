FactoryGirl.define do
  factory :retranslator, class: Retranslator do
    port_from 31072
    port_to   31073
    replacement_port  31074
    active  true
  end
end