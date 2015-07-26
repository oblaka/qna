require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :votes }
  it { should have_many :auths }

  let!( :user ) { create :user }
  let!( :another_user ) { create :user }
  let( :auth_hash ) { OmniAuth::AuthHash.new( provider: 'facebook', uid: '123456' ) }

  describe '.find_oauth' do
    context 'user exist' do
      context 'and have facebook auth' do
        it 'returnes user' do
          user.auths.create( provider: 'facebook', uid: '123456' )
          expect( User.find_oauth( auth_hash ) ).to eq user
        end
      end

      context 'and not have facebook auth' do
        let( :auth_hash ) do
          OmniAuth::AuthHash.new( provider: 'facebook', uid: '123456',
                                  info: { email: user.email } )
        end
        it 'does not create new user' do
          expect { User.find_oauth( auth_hash ) }.to_not change( User, :count )
        end

        it 'creates auth for user' do
          expect { User.find_oauth( auth_hash ) }.to change( user.auths, :count ).by( 1 )
        end

        it 'creates auth by provider and uid' do
          auth = User.find_oauth( auth_hash ).auths.first

          expect( auth.provider ).to eq auth_hash.provider
          expect( auth.uid ).to eq auth_hash.uid
        end

        it 'returns the user' do
          expect( User.find_oauth( auth_hash ) ).to eq user
        end
      end
      context 'absolutely new user' do
        context 'hash with email' do
          let( :auth_hash ) do
            OmniAuth::AuthHash.new( provider: 'facebook', uid: '123456',
                                    info: { email: 'new@user.com' } )
          end

          it 'creates user' do
            expect { User.find_oauth( auth_hash ) }.to change( User, :count ).by( 1 )
          end

          it 'returns user' do
            expect( User.find_oauth( auth_hash ) ).to be_a( User )
          end

          it 'fills user email' do
            user = User.find_oauth( auth_hash )
            expect( user.email ).to eq auth_hash.info[:email]
          end

          it 'creates auth for user' do
            user = User.find_oauth( auth_hash )
            expect( user.auths ).to_not be_empty
          end

          it 'creates auth with provider and uid' do
            auth = User.find_oauth( auth_hash ).auths.first

            expect( auth.provider ).to eq auth_hash.provider
            expect( auth.uid ).to eq auth_hash.uid
          end
        end

        context 'hash without email' do
          let( :auth_hash ) do
            OmniAuth::AuthHash.new( provider: 'facebook', uid: '123456',
                                    info: {} )
          end

          it 'not creates new user' do
            expect { User.find_oauth( auth_hash ) }.to_not change( User, :count )
          end

          it 'returns new user' do
            expect( User.find_oauth( auth_hash ) ).to be_a_new User
          end
        end
      end
    end
  end

  describe '.confirmed_by' do
    context 'user with email not exist' do
      it 'creates user' do
        expect { User.confirmed_by('user@example.com') }.to change( User, :count ).by( 1 )
      end

      it 'returns user' do
        expect( User.confirmed_by( 'user@example.com' ) ).to be_a( User )
      end

      it 'returned user already confirmed' do
        expect( User.confirmed_by( 'user@example.com' ).confirmed? ).to eq true
      end
    end

    context 'user with email exist' do
      it 'raise exception' do
        expect { User.confirmed_by( user.email ) }.to raise_exception ActiveRecord::RecordInvalid
      end
    end
  end

  describe '.unconfirmed_by' do
    context 'user with email not exist' do
      it 'creates user' do
        expect { User.unconfirmed_by('user@example.com') }.to change( User, :count ).by( 1 )
      end

      it 'returns user' do
        expect( User.unconfirmed_by( 'user@example.com' ) ).to be_a( User )
      end

      it 'returned user unconfirmed' do
        expect( User.unconfirmed_by( 'user@example.com' ).confirmed? ).to eq false
      end
    end

    context 'user with email exist' do
      it 'not change db' do
        expect { User.unconfirmed_by( user.email ) }.to_not change( User, :count )
      end

      it 'returns user' do
        expect( User.unconfirmed_by( user.email ) ).to be_a( User )
      end

      it 'returned user unconfirmed' do
        expect( User.unconfirmed_by( user.email ).confirmed? ).to eq true
      end
    end
  end

  describe '#add_auth_by' do
    context 'user not yet have auth' do
      it 'create auth for user in db' do
        user
        expect { user.add_auth_by( auth_hash ) }.to change(user.auths, :count).by 1
      end
      it 'returns true' do
        expect( user.add_auth_by( auth_hash ) ).to eq true
      end
    end
    context 'user already have auth' do
      before { user.add_auth_by auth_hash }
      it 'dont change auths' do
        expect { user.add_auth_by( auth_hash ) }.to_not change(Auth, :count)
      end
      it 'returns false' do
        expect( user.add_auth_by( auth_hash ) ).to eq false
      end
    end
    context 'another user already have this auth' do
      before { another_user.add_auth_by auth_hash }
      it 'dont change auths count' do
        expect { user.add_auth_by( auth_hash ) }.to_not change(Auth, :count)
      end
    end
  end
end
