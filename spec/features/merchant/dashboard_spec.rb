require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As a merchant' do
    describe 'When I visit my merchant dashboard' do
      it 'should see the name of my merchant' do
        merchant = create(:merchant)

        visit "/merchant/#{merchant.id}/dashboard"

        expect(page).to have_content(merchant.name)
      end

      it 'should see links to items index and invoices index' do
        merchant = create(:merchant)

        visit "merchant/#{merchant.id}/dashboard"

        within '.links' do
          expect(page).to have_link('Items')
          expect(page).to have_link('Invoices')
        end
      end
    end
  end
end