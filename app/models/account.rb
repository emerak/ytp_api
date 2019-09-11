# frozen_string_literal: true

class Account < ApplicationRecord
  monetize :balance_cents

  belongs_to :user
  has_many :movements

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def deposit!(amount)
    amount = Money.new(amount) * 100
    Account.transaction do
      update!(balance: balance + amount)
      movements.create!(amount: amount, operation: 'deposit')
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
