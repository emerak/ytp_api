# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TransferService do
  let(:service) { described_class.new("", {})}

  describe "#call" do
    context "with empty params" do
      it 'returns an error' do
        service.call

        expect(service.errors.full_messages).to eql(
          [
            "can't make deposit on this user",
            'invalid account',
            'invalid amount',
            'incorrect clabe'
          ]
        )
      end
    end

    context "user is admin" do
      let(:user) { create(:user, :admin, token: '333') }
      let(:service) { described_class.new(user.token, { destination: '888', amount: '10' })}

      it 'returns an error' do
        service.call

        expect(service.errors.full_messages).to eql(
          ["can't make deposit on this user", 'invalid account', 'incorrect clabe']
        )
      end
    end

    context 'no amount' do
      let(:user) { create(:user, :holder, token: '333') }
      let!(:external_account) { create(:external_account, user: user, clabe: '888') }
      let(:service) { described_class.new(user.token, { destination: external_account.clabe })}

      it 'returns an error' do
        service.call

        expect(service.errors.full_messages).to eql(
          ['invalid amount']
        )
      end
    end

  end
end
