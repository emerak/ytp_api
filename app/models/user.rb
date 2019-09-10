# frozen_string_literal: true
class User < ApplicationRecord
  has_secure_password

  enum role: { 'admin': 0, 'holder': 1 }
  # Email validation from ruby docs
  # https://www.rubydoc.info/stdlib/uri/URI/MailTo
  validates :email, uniqueness: true,
                    presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
  validates :role, inclusion: { in: User.roles.keys },
                   presence: true

  has_one :account
  has_one :external_account

  after_create_commit :create_account, if: -> { holder? }

  def create_external_account!
    # User already has an account
    return unless external_account.nil?

    # Autogenerate the CLABE
    loop do
      clabe = ClabeGenerator.generate
      unless ExternalAccount.where(clabe: clabe).exists?
        create_external_account(balance: 0.0, clabe: clabe)
        break
      end
    end
  end

  private

  def create_account
    self.create_account!(balance: 0.0)
  end
end
