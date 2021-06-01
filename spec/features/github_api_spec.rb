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
        expect(page).to have_content('Commits: kevxo - 147 BrianZanti - 39 timomitchel - 9 scottalexandra - 3')
      end

      visit '/admin/merchants'

      within '.commit-count' do
        expect(page).to have_content('Commits: kevxo - 147 BrianZanti - 39 timomitchel - 9 scottalexandra - 3')
      end

      visit '/admin/invoices'

      within '.commit-count' do
        expect(page).to have_content('Commits: kevxo - 147 BrianZanti - 39 timomitchel - 9 scottalexandra - 3')
      end
    end

    it 'should see a list of closed PRS' do
      visit '/admin'

      within '.pull-requests' do
        expect(page).to have_content('Pull Requests: 28')
      end

      visit '/admin/merchants'

      within '.pull-requests' do
        expect(page).to have_content('Pull Requests: 28')
      end

      visit '/admin/invoices'

      within '.pull-requests' do
        expect(page).to have_content('Pull Requests: 28')
      end
    end
  end
end