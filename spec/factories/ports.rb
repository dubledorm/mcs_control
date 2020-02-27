FactoryGirl.define do
  factory :port, class: Port do
    sequence(:number) { |n| NginxConfig.first_port(:http) + n }
    port_type 'http'
    program
  end

  factory :tcp_port, class: Port do
    sequence(:number) { |n| NginxConfig.first_port(:tcp) + n }
    port_type 'tcp'
    program
  end
end

# FactoryGirl.define do
#   factory :port, class: Port do
#     sequence(:number) { |n| Port::RANGE_OF_NUMBER[:http][:left_range] + n }
#     port_type 'http'
#     program
#   end
#
#   factory :tcp_port, class: Port do
#     sequence(:number) { |n| Port::RANGE_OF_NUMBER[:tcp][:left_range] + n }
#     port_type 'tcp'
#     program
#   end
# end
