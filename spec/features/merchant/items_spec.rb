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

    it "should have a link to update an Item" do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items/#{item1.id}"

      expect(page).to have_link('Update Item')
      click_link 'Update Item'

      expect(current_path).to eq("/merchant/#{merchant.id}/items/#{item1.id}/edit")
    end

    it "should fill out a form to update Item" do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items/#{item1.id}/edit"

      fill_in :name, with: 'Awesome Macboook Pro 2000'
      fill_in :description, with: 'Works great and there 3 in the whole world'
      fill_in :unit_price, with: 2000

      click_button 'Update'

      expect(current_path).to eq("/merchant/#{merchant.id}/items/#{item1.id}")
      expect(page).to have_content('Item has been successfully updated!')
    end
  end
end