require 'rails_helper'


RSpec.describe 'As a Admin' do
  describe 'When I visit the admin dashboard' do
    it 'should see a header indicating that im in admin dashboard' do
      visit '/admin'

      expect(page).to have_content('Welcome to The Admin Dashboard')
    end
  end
end