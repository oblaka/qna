shared_examples 'api success' do
  it 'returnes 200' do
    do_request access_token: access_token.token
    expect( response ).to be_success
  end
end
