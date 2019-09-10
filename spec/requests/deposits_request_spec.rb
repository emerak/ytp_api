# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Deposits', type: :request do
  let(:holder) { create(:user, :holder) }
  let!(:account) { create(:account, user: holder) }

  before do
    allow_any_instance_of(ApplicationController).to \
      receive(:authenticate_user!).and_return(true)

    allow_any_instance_of(ApplicationController).to \
      receive(:can_perform?).and_return(true)
  end


  describe '#post' do
    context 'Successful' do
      it 'increases the balance' do
        post v1_deposits_path,
          params: { email: holder.email, amount: '10' }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(body['balance']).to eql('10')
      end
    end

    context 'Error' do
      context 'no user email' do
        it 'does not creates a holder user' do
          post v1_deposits_path,
            params: { email: '', amount: '10' }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'no amount' do
        it 'does not creates a holder user' do
          post v1_deposits_path,
            params: { email: holder.email, amount: '' }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
