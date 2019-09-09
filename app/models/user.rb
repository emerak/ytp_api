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

end
