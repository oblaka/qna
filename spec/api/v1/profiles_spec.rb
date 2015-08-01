require 'rails_helper'

describe 'Profile API' do
  let( :me ) { create :user }
  let(:access_token ) { create :access_token, resource_owner_id: me.id }

  describe 'GET #profile' do
    let(:url) { '/api/v1/profiles/me' }
    context 'unauthorized' do
      it 'returnes 401 if no access_token' do
        get url, format: :json
        expect( response.status ).to eq 401
      end

      it 'returnes 401 if invalid access_token' do
        get url, format: :json, access_token: 'someshit'
        expect( response.status ).to eq 401
      end
    end

    context 'authorized' do
      before { get url, format: :json, access_token: access_token.token }

      it 'returnes 200' do
        expect( response ).to be_success
      end

      %w{ id email created_at updated_at }.each do |attr|
        it "contain #{attr}" do
          expect( response.body ).to be_json_eql( me.email.to_json ).at_path( 'email' )
        end
      end

      %w{ password encrypted_password }.each do |attr|
        it "does not contain #{attr}" do
          expect( response.body ).to_not have_json_path( attr )
        end
      end
    end
  end

  describe 'GET #index' do
    let(:url) { '/api/v1/profiles' }
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get url, format: :json
        expect( response ).to have_http_status 401
      end

      it 'returns 401 status if invalid access_token' do
        get url, format: :json, access_token: 'someshit'
        expect( response ).to have_http_status 401
      end
    end

    context 'authorized' do
      let!( :users ) { create_list( :user, 3 ) }

      before { get url, format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect( response ).to be_success
      end

      it 'contains a list of users' do
        expect( response.body ).to be_json_eql( users.to_json ).at_path 'profiles'
      end

      it 'does not containt requesting user' do
        expect( response.body ).not_to include_json( me.to_json ).at_path 'profiles'
      end

      %w( id email created_at updated_at ).each do |attr|
        it "contains #{attr}" do
          expect( response.body ).to be_json_eql( users.first.send( attr.to_sym ).to_json )
            .at_path( "profiles/0/#{attr}" )
        end
      end

      %w( password encrypted_password ).each do |attr|
        it "does not contain #{attr}" do
          expect( response.body ).to_not have_json_path( "profiles/0/#{attr}" )
        end
      end
    end
  end
end
