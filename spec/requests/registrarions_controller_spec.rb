# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let(:user) { create(:user, :admin) }

  describe '#post' do
    context 'Successful' do
      before do
        allow_any_instance_of(ApplicationController).to \
          receive(:authenticate_user!).and_return(true)

        allow_any_instance_of(V1::RegistrationsController).to \
          receive(:can_create?).and_return(true)
      end

      it 'creates a holder user' do
        post v1_registrations_path,
          params: { user: { email: 'holder@test.com', password: 'myholderpwd' } }

        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        post v1_registrations_path,
          params: { user: { email: 'holder@test.com', password: 'myholderpwd' } }

        body = JSON.parse(response.body)

        expect(body['user']['email']).to eql('holder@test.com')
      end
    end

    context 'Error' do
      before do
        allow_any_instance_of(ApplicationController).to \
          receive(:authenticate_user!).and_return(true)

        allow_any_instance_of(V1::RegistrationsController).to \
          receive(:can_create?).and_return(true)
      end

      context "no user email" do
        it 'does not creates a holder user' do
          post v1_registrations_path,
            params: { user: { email: '', password: 'myholderpwd' } }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "no user password" do
        it 'does not creates a holder user' do
          post v1_registrations_path,
            params: { user: { email: 'holder@test.com', password: '' } }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
