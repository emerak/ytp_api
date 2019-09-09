# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '#email' do
    it { should validate_presence_of(:email) }
    it { should_not allow_value('invalid').for(:email) }
  end

  describe '#password' do
    it { should validate_presence_of(:password) }
    it { should_not allow_value('test').for(:password) }
    it { should allow_value('strongpassw0rd').for(:password) }
  end

  describe '#role' do
    it { should validate_presence_of(:role) }
    it { should allow_values('holder', 'admin').for(:role) }

    it 'does not allow any other role besides admin and holder' do
      expect{
        User.new(role: 'accountant')
      }.to raise_error(ArgumentError, "'accountant' is not a valid role")
    end
  end
end
