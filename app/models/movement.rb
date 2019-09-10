class Movement < ApplicationRecord
  monetize :amount_cents

  belongs_to :account

  enum operation: { deposit: 0, withdrawal: 1 }
end
