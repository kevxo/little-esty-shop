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

  describe 'When I click on an item' do
    it 'should take me to the item show page and the items attributes' do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        expect(page).to have_link(item1.name)

        click_link item1.name
      end

      expect(current_path).to eq("/merchant/#{merchant.id}/items/#{item1.id}")

      within '.item-info' do
        expect(page).to have_content("Name: #{item1.name}")
        expect(page).to have_content("Description: #{item1.description}")
        expect(page).to have_content("Current Selling Price: $#{item1.unit_price}")
      end
    end
  end
end