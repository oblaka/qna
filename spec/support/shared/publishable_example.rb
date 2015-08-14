shared_examples 'api publishable' do
  it 'publish record to channel' do
    expect(PrivatePub).to receive(:publish_to).with(channel, anything)
    do_request access_token: access_token.token
  end
end
