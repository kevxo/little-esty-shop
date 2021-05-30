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

    it 'should see the commit count for each contributor' do
      visit '/admin'

      within '.commit-count' do
        expect(page).to have_content('Commits: kevxo - 146 BrianZanti - 39 timomitchel - 9 scottalexandra - 3')
      end

      visit '/admin/merchants'

      within '.commit-count' do
        expect(page).to have_content('Commits: kevxo - 146 BrianZanti - 39 timomitchel - 9 scottalexandra - 3')
      end

      visit '/admin/invoices'

      within '.commit-count' do
        expect(page).to have_content('Commits: kevxo - 146 BrianZanti - 39 timomitchel - 9 scottalexandra - 3')
      end
    end
  end
end