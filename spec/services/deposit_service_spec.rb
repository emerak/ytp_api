# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DepositService do
  let(:service) { described_class.new({})}

  describe "#call" do
    context "with empty params" do
      it 'returns an error' do
        service.call

        #expect(service.errors.size).to eql(3)
        expect(service.errors.full_messages).to eql(
          ["can't make deposit on this user",
           'invalid account',
           'invalid amount']
        )
      end
    end

    context "user is admin" do
      let(:user) { create(:user, :admin) }
      let(:service) { described_class.new({ email: user.email, amount: '10' })}

      it 'returns an error' do
        service.call

        expect(service.errors.full_messages).to eql(
          ["can't make deposit on this user", "invalid account"]
        )
      end
    end

    context "no amount" do
      let(:user) { create(:user, :holder) }
      let(:service) { described_class.new({ email: user.email })}

      it 'returns an error' do
        service.call

        expect(service.errors.full_messages).to eql(
          ["invalid amount"]
        )
      end
    end

  end
end
