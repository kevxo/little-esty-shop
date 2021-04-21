require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As a merchant' do
    describe 'When I visit my merchant dashboard' do
      it 'should see the name of my merchant' do
        merchant = create(:merchant)

        visit "/merchant/#{merchant.id}/dashboard"

        expect(page).to have_content(merchant.name)
      end
    end
  end
end