require 'rails_helper'

RSpec.describe 'As a admin or visitor' do
  describe 'When I visit any page on the site' do
    it 'should see the name of the GitHub repo somewhere on the site' do
      visit '/admin'

      expect(page).to have_content('little-esty-shop')

      visit '/admin/merchants'

      expect(page).to have_content('little-esty-shop')

      visit '/admin/invoices'

      expect(page).to have_content('little-esty-shop')
    end

    it 'should see my username and teamates username' do
      visit '/admin'

      expect(page).to have_content('Authors: kevxo, BrianZanti, timomitchel, scottalexandra')

      visit '/admin/merchants'

      expect(page).to have_content('Authors: kevxo, BrianZanti, timomitchel, scottalexandra')

      visit '/admin/invoices'

      expect(page).to have_content('Authors: kevxo, BrianZanti, timomitchel, scottalexandra')
    end
  end
end