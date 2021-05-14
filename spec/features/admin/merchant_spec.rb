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
  end
end