FactoryGirl.define do
  factory :nginx_template, class: NginxTemplate do
    program_type 'pp-admin'
    content_http '12345 http'
    content_tcp '12345 tcp'
  end

  factory :nginx_template_with_instance, parent: :nginx_template do
    instance
  end
end
