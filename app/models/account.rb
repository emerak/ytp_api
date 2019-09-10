# frozen_string_literal: true

class Account < ApplicationRecord
  monetize :balance_cents

  belongs_to :user
  has_many :movements

  validates :balance, numericality: { greater_than_or_equal_to: 0, message: 'Not enough funds in you account' }

  def deposit!(amount)
    amount = Money.new(amount) * 100
    Account.transaction do
      update_attributes!(balance: balance + amount)
      Movement.transaction do
        movements.create!(amount: amount, operation: 'deposit')
      end
    end
  end

  def transfer!(amount)
    amount = Money.new(amount) * 100
    Account.transaction do
      update!(balance: balance - amount)
      movements.create!(amount: amount, operation: 'withdrawal')
      user.external_account.update!(balance: user.external_account.balance + amount)
    end
  end
end
