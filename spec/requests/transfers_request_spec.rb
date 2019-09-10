# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Transfers', type: :request do
  let(:holder) { create(:user, :holder) }
  let(:external_account) {
    create(:external_account,
           user: holder,
           balance: 0,
           clabe: ClabeGenerator.generate)
  }

  before do
    allow_any_instance_of(ApplicationController).to \
      receive(:authenticate_user!).and_return(true)
  end


  describe '#post' do
    context 'Holder has the funds' do
      it 'increases the balance' do
        holder.account.update(balance: 20)

        post v1_transfers_path,
             params: { destination: external_account.clabe, amount: '10' }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(body['balance']).to eql('10')
      end
    end

    context 'Not enough funds' do
      it 'returns the validation error' do
        holder.account.update(balance: 0)

        post v1_transfers_path,
             params: { destination: external_account.clabe, amount: '10' }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body['errors']).to eql(['Validation failed: Balance Not enough funds in you account'])
      end
    end
  end
end
