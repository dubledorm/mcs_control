RSpec.shared_examples 'redirect to login page' do
  it 'should redirect to login page' do
    expect(subject).to redirect_to(new_admin_user_session_path)
  end
end

RSpec.shared_examples 'get response 403' do
  it 'response' do
    subject
    expect(response).to have_http_status(403)
  end
end

RSpec.shared_examples 'get response 404' do
  it 'response' do
    subject
    expect(response).to have_http_status(404)
  end
end