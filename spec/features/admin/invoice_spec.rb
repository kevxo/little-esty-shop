require 'rails_helper'

RSpec.describe 'As a Admin' do
  describe 'When I visit the admin Invoices Index' do
    it 'should see a list of Ivoice ids that link to invoice show page' do
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      invoice3 = create(:invoice)

      visit '/admin/invoices'

      within '.invoices' do
        expect(page).to have_content(invoice1.id)
        expect(page).to have_content(invoice2.id)
        expect(page).to have_content(invoice3.id)
        expect(page).to have_link(invoice1.id)

        click_link invoice1.id
      end

      expect(current_path).to eq("/admin/invoices/#{invoice1.id}")
    end
  end
end