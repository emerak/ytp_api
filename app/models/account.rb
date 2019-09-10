# frozen_string_literal: true

class Account < ApplicationRecord
  monetize :balance_cents

  belongs_to :user
  has_many :movements

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
      update_attributes!(balance: balance - amount)
      Movement.transaction do
        movements.create!(amount: amount, operation: 'withdrawal')
      end
    end
  end
end
