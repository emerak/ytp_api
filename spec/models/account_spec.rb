require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:user) { create(:user, :holder) }
  let(:account) { create(:account, user: user, balance: 11.00) }
  let!(:external_account) { create(:external_account, user: user, balance: 0) }

  it { should belong_to(:user) }
  it { should have_many(:movements) }

  describe '#transfer!' do
    context "When balance is positive" do
      it 'substracts money from the account' do
        account.transfer!(10)

        expect(account.balance.format).to eql("1")

      end

      it 'creates a withdrawal movement' do
        account.transfer!(10)

        expect(account.movements.count).to eql(1)
        expect(account.movements.first.amount.format).to eql('10')
        expect(account.movements.first.operation).to eql('withdrawal')
      end

      it 'saves new balance on external account' do
        expect(user.external_account.balance.format).to eql('0')

        account.transfer!(10)

        expect(user.external_account.balance.format).to eql('10')
      end
    end

    context 'When balance is 0' do
      let(:account) { create(:account, user: user, balance: 0) }

      it 'raises validation on balance' do
        expect{account.transfer!(10)}.to  \
          raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Balance must be greater than or equal to 0')
      end
    end
  end

  describe '#deposit!' do
    it 'adds money to the account' do
      account.deposit!(10)

      expect(account.balance.format).to eql("21")

    end

    it 'creates a deposit movement' do
      account.deposit!(10)

      expect(account.movements.count).to eql(1)
      expect(account.movements.first.amount.format).to eql('10')
      expect(account.movements.first.operation).to eql('deposit')
    end

    context 'When deposit is negative' do
      let(:account) { create(:account, user: user, balance: 0) }

      it 'raises validation on balance' do
        expect{account.deposit!(-10)}.to  \
          raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Balance must be greater than or equal to 0')
      end
    end
  end
end
