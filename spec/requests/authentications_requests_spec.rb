# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  let(:user) { create(:user, :admin) }

  describe '#post' do
    context 'Successful' do
      it 'authenticates a user' do
        post v1_login_path,
             params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status(:success)
      end

      it 'returns a token' do
        allow(JwtEncoder).to receive(:encode).and_return('mockedtoken')

        post v1_login_path,
             params: { user: { email: user.email, password: user.password } }

        body = JSON.parse(response.body)

        expect(body['token']).to eql('mockedtoken')
      end
    end

    context 'Error' do
      context 'incorrect email' do
        it 'does not authenticates a user' do
          post v1_login_path,
               params: { user: { email: 'random@test.com', password: user.password } }

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'incorrect password' do
        it 'does not authenticates a user' do
          post v1_login_path,
               params: { user: { email: user.email, password: 'somepassword' } }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      it 'does not returns a token' do
        allow(JwtEncoder).to receive(:encode).and_return('mockedtoken')

        post v1_login_path, params: { user: { email: '', password: '' } }

        body = JSON.parse(response.body)

        expect(body['token']).to be_nil
      end
    end
  end
end
