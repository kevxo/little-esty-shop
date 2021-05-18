require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with(%i[Enable Disable])}
  end
end
