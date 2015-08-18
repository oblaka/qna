require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { create(:user) }

  describe 'GET #show' do
    context 'any user' do
      before { get :show, id: user }
      it 'assign requested user to @user' do
        expect(assigns(:user)).to eq user
      end
      it 'render show view' do
        expect(response).to render_template :show
      end
    end
  end
end
