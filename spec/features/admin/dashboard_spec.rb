require 'rails_helper'


RSpec.describe 'As a Admin' do
  describe 'When I visit the admin dashboard' do
    it 'should see a header indicating that im in admin dashboard' do
      visit '/admin'

      expect(page).to have_content('Welcome to The Admin Dashboard')
    end

    it 'should see links to the admin merchants and the admin invoices' do
      visit '/admin'

      expect(page).to have_link('Admin Merchants')
      expect(page).to have_link('Admin Invoices')

      click_link 'Admin Merchants'

      expect(current_path).to eq('/admin/merchants')

      visit '/admin'

      click_link 'Admin Invoices'

      expect(current_path).to eq('/admin/invoices')
    end
  end
end