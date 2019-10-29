FactoryGirl.define do
  factory :nginx_template, class: NginxTemplate do
    program_type 'pp-admin'
    content_http '12345 http'
    content_tcp '12345 tcp'
  end
end
