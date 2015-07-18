require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env['omniauth.auth'] = auth_hash
  end
  let( :user ) { create :user, email: 'new@user.com' }
  let( :another_user ) { create :user }
  let!( :auth_hash ) { OmniAuth::AuthHash.new( provider: 'facebook', uid: '123456',
                                               info: { email: 'new@user.com' } ) }

  describe 'confirm_email' do
    context 'user with email not exist' do
      it 'creates user' do
        expect { post :confirm_email, user: { email: 'user@example.com' } }.to change( User, :count ).by 1
      end

      it 'returned user unconfirmed' do
        post :confirm_email, user: { email: 'user@example.com' }
        expect( assigns( :user ).confirmed? ).to eq false
      end
    end

    context 'user with email exist' do
      context 'and already confirmed' do
        before { user }
        it 'not change users in db' do
          expect { post :confirm_email, user: {email: user.email} }.to_not change( User, :count )
        end

        it 'returned user unconfirmed' do
          post :confirm_email, user: { email: user.email }
          expect( assigns( :user ).confirmed? ).to eq true
        end

        it 'redirects to sign_in' do
          post :confirm_email, user: { email: user.email }
          expect(response).to redirect_to new_user_session_path
        end
      end
      context 'and still unconfirmed' do
        before { user.update(confirmed_at: nil) }
        it 'not change users in db' do
          expect { post :confirm_email, user: {email: user.email} }.to_not change( User, :count )
        end

        it 'returned user confirmed' do
          post :confirm_email, user: { email: user.email }
          expect( assigns( :user ).confirmed? ).to eq false
        end

        it 'redirects to root' do
          post :confirm_email, user: { email: user.email }
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe 'POST #facebook' do
    let( :auth ) { create :fb_auth, uid: '123456', user: user }
    context 'auth_hash with email' do
      context 'and auth exists' do
        before { auth }
        it 'not change users count in db' do
          expect { post :facebook, auth_hash }.to_not change( User, :count )
        end

        # FIXME!
        it 'not change auths count in db' do
          expect { post :facebook, auth_hash }.to_not change( Auth, :count )
        end
        it 'assign user to @user' do
          post :facebook, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :facebook, auth_hash
          expect(response).to redirect_to profile_path
        end
      end

      context 'and user with email exists' do
        before { user }
        it 'not change users count in db' do
          expect { post :facebook, auth_hash }.to_not change( User, :count )
        end
        it 'create auth in db' do
          expect { post :facebook, auth_hash }.to change( Auth, :count ).by 1
        end
        it 'assign user to @user' do
          post :facebook, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :facebook, auth_hash
          expect(response).to redirect_to profile_path
        end
      end

      context 'absolutely new user' do
        it 'creates user' do
          expect { post :facebook, auth_hash }.to change( User, :count ).by 1
        end
        it 'create auth in db' do
          expect { post :facebook, auth_hash }.to change( Auth, :count ).by 1
        end
        it 'assign user to @user' do
          post :facebook, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :facebook, auth_hash
          expect(response).to redirect_to profile_path
        end
      end
    end

    context 'auth_hash without email' do
      let!( :auth_hash ) { OmniAuth::AuthHash.new( provider: 'facebook', uid: '123456',
                                                   info: {  } ) }
      it 'assign new user to @user' do
        post :facebook, auth_hash
        expect( assigns( :user ) ).to be_a_new User
      end
      it 'redirects to registration' do
        post :facebook, auth_hash
        expect(response).to render_template 'email_form'
      end
    end
  end

  describe 'POST #twitter' do
    let( :auth ) { create :tw_auth, uid: '123456', user: user }
    context 'auth_hash with email' do
      let!( :auth_hash ) { OmniAuth::AuthHash.new( provider: 'twitter', uid: '123456',
                                                   info: { email: 'new@user.com' } ) }
      context 'and auth exists' do
        before { auth }
        it 'not change users count in db' do
          expect { post :twitter, auth_hash }.to_not change( User, :count )
        end
        it 'not change auths count in db' do
          expect { post :twitter, auth_hash }.to_not change( Auth, :count )
        end
        it 'assign user to @user' do
          post :twitter, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :twitter, auth_hash
          expect(response).to redirect_to profile_path
        end
      end

      context 'and user with email exists' do
        before { user }
        it 'not change users count in db' do
          expect { post :twitter, auth_hash }.to_not change( User, :count )
        end
        it 'create auth in db' do
          expect { post :twitter, auth_hash }.to change( Auth, :count ).by 1
        end
        it 'assign user to @user' do
          post :twitter, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :twitter, auth_hash
          expect(response).to redirect_to profile_path
        end
      end

      context 'absolutely new user' do
        it 'creates user' do
          expect { post :twitter, auth_hash }.to change( User, :count ).by 1
        end
        it 'create auth in db' do
          expect { post :twitter, auth_hash }.to change( Auth, :count ).by 1
        end
        it 'assign user to @user' do
          post :twitter, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :twitter, auth_hash
          expect(response).to redirect_to profile_path
        end
      end
    end

    context 'auth_hash without email' do
      let!( :auth_hash ) { OmniAuth::AuthHash.new( provider: 'twitter', uid: '123456',
                                                   info: {  } ) }
      it 'assign new user to @user' do
        post :twitter, auth_hash
        expect( assigns( :user ) ).to be_a_new User
      end
      it 'redirects to registration' do
        post :twitter, auth_hash
        expect(response).to render_template 'email_form'
      end
    end
  end

  describe 'POST #vkontakte' do
    let( :auth ) { create :vk_auth, uid: '123456', user: user }
    context 'auth_hash with email' do
      let!( :auth_hash ) { OmniAuth::AuthHash.new( provider: 'vkontakte', uid: '123456',
                                                   info: { email: 'new@user.com' } ) }
      context 'and auth exists' do
        before { auth }
        it 'not change users count in db' do
          expect { post :vkontakte, auth_hash }.to_not change( User, :count )
        end
        it 'not change auths count in db' do
          expect { post :vkontakte, auth_hash }.to_not change( Auth, :count )
        end
        it 'assign user to @user' do
          post :vkontakte, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :vkontakte, auth_hash
          expect(response).to redirect_to profile_path
        end
      end

      context 'and user with email exists' do
        before { user }
        it 'not change users count in db' do
          expect { post :vkontakte, auth_hash }.to_not change( User, :count )
        end
        it 'create auth in db' do
          expect { post :vkontakte, auth_hash }.to change( Auth, :count ).by 1
        end
        it 'assign user to @user' do
          post :vkontakte, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :vkontakte, auth_hash
          expect(response).to redirect_to profile_path
        end
      end

      context 'absolutely new user' do
        it 'creates user' do
          expect { post :vkontakte, auth_hash }.to change( User, :count ).by 1
        end
        it 'create auth in db' do
          expect { post :vkontakte, auth_hash }.to change( Auth, :count ).by 1
        end
        it 'assign user to @user' do
          post :vkontakte, auth_hash
          expect( assigns( :user ).email ).to eq 'new@user.com'
        end
        it 'redirects to root' do
          post :vkontakte, auth_hash
          expect(response).to redirect_to profile_path
        end
      end
    end

    context 'auth_hash without email' do
      let!( :auth_hash ) { OmniAuth::AuthHash.new( provider: 'vkontakte', uid: '123456',
                                                   info: {  } ) }
      it 'assign new user to @user' do
        post :vkontakte, auth_hash
        expect( assigns( :user ) ).to be_a_new User
      end
      it 'redirects to registration' do
        post :vkontakte, auth_hash
        expect(response).to render_template 'email_form'
      end
    end
  end
end
