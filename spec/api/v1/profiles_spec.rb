require 'rails_helper'

describe 'Profile API' do
  let( :me ) { create :user }
  let(:access_token ) { create :access_token, resource_owner_id: me.id }

  describe 'GET #profile' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'api unauthorized'
    it_behaves_like 'api success'

    context 'authorized' do
      before { do_request access_token: access_token.token }

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
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'api unauthorized'
    it_behaves_like 'api success'

    context 'authorized' do
      let!( :users ) { create_list( :user, 3 ) }

      before { do_request access_token: access_token.token }

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

  def do_request(params={})
    get api_path, { format: :json }.merge(params)
  end
end
