require 'rails_helper'

RSpec.describe 'As a admin' do
  describe 'When I visit the admin merchants index page' do
    before(:each) do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)
      @merchant4 = create(:merchant)
      @merchant5 = create(:merchant)

    end

    it 'should see the name of each merchant in the system' do
      visit '/admin/merchants'


      within '.all-merchants' do
        expect(page).to have_content(@merchant1.name)
        expect(page).to have_content(@merchant2.name)
        expect(page).to have_content(@merchant3.name)
        expect(page).to have_content(@merchant4.name)
        expect(page).to have_content(@merchant5.name)
      end
    end

    it 'should click on name and be directed to the merchant show page' do
      visit '/admin/merchants'

      within '.all-merchants' do
        expect(page).to have_link(@merchant1.name)

        click_link @merchant1.name
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")
      expect(page).to have_content(@merchant1.name)
      expect(page).to_not have_content(@merchant2.name)
    end
  end

  describe 'When I visit the merchants show page' do
    it 'should see a link to update the merchant and see a flash message after update' do
      merchant = create(:merchant)

      visit "/admin/merchants/#{merchant.id}"

      expect(page).to have_link('Update Merchant')

      click_link 'Update Merchant'

      expect(current_path).to eq("/admin/merchants/#{merchant.id}/edit")

      fill_in :name, with: 'Kevin Cuadros'

      click_button 'Submit'

      expect(current_path).to eq("/admin/merchants/#{merchant.id}")
      expect(page).to have_content('Kevin Cuadros')
      expect(page).to have_content('Information has been successfully updated!')
    end
  end
end