shared_context 'api unauthorized' do
  it 'returnes 401 if no access_token' do
    do_request
    expect(response).to have_http_status :unauthorized
  end

  it 'returnes 401 if invalid access_token' do
    do_request( access_token: 'someshit' )
    expect(response).to have_http_status :unauthorized
  end
end