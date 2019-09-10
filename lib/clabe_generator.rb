# frozen_string_literal: true

module ClabeGenerator
  include Clabe

  def self.generate
    bank = Clabe::BANKS.keys.sample
    city = Clabe::CITIES.keys.sample
    account = 11.times.map{ SecureRandom.random_number(9) }.join
    clabe = "#{bank}#{city}#{account}"
    checksum = Clabe.send(:compute_checksum, clabe)
    "#{clabe}#{checksum}"
  end
end
