shared_context 'api unprocessable' do

  context 'if params is not valid' do
    before do
      do_request( access_token: access_token.token, object_symbol => { body: nil } )
    end

    it 'returnes 422' do
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'contain errors ' do
      expect( response.body ).to have_json_path( 'errors/body' )
    end
  end

  it 'not publish answer to channel' do
    expect(PrivatePub).to_not receive(:publish_to)
    do_request( access_token: access_token.token, object_symbol => { body: nil } )
  end

end
