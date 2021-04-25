require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I visit my merchant items index page' do
    it 'should see a list of all my items' do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      item3 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        expect(page).to have_content(item1.name)
        expect(page).to have_content(item2.name)
        expect(page).to have_content(item3.name)
      end
    end

    it 'should not see other merchants items' do
      merchant = create(:merchant)
      merchant2 = create(:merchant)

      item1 = create(:item, merchant_id: merchant2.id)
      item2 = create(:item, merchant_id: merchant2.id)
      item3 = create(:item, merchant_id: merchant2.id)

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        expect(page).to_not have_content(item1.name)
        expect(page).to_not have_content(item2.name)
        expect(page).to_not have_content(item3.name)
      end
    end
  end
end