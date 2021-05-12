require 'rails_helper'


RSpec.describe 'As a Admin' do
  describe 'When I visit the admin dashboard' do
    before(:each) do
      @merchant = create(:merchant)

      @customer1 = create(:customer)
      @customer2 = create(:customer)
      @customer3 = create(:customer)
      @customer4 = create(:customer)
      @customer5 = create(:customer)

      @item1 = create(:item, merchant_id: @merchant.id)
      @item2 = create(:item, merchant_id: @merchant.id)
      @item3 = create(:item, merchant_id: @merchant.id)
      @item4 = create(:item, merchant_id: @merchant.id)

      @invoice1 = create(:invoice, customer_id: @customer1.id)
      @invoice2 = create(:invoice, customer_id: @customer1.id)
      @invoice3 = create(:invoice, customer_id: @customer2.id)
      @invoice4 = create(:invoice, customer_id: @customer2.id)
      @invoice5 = create(:invoice, customer_id: @customer2.id)
      @invoice6 = create(:invoice, customer_id: @customer3.id)
      @invoice7 = create(:invoice, customer_id: @customer4.id)
      @invoice8 = create(:invoice, customer_id: @customer5.id)

      create(:transaction, invoice_id: @invoice1.id)
      create(:transaction, invoice_id: @invoice2.id)
      create(:transaction, invoice_id: @invoice3.id)
      create(:transaction, invoice_id: @invoice4.id)
      create(:transaction, invoice_id: @invoice5.id)
      create(:transaction, invoice_id: @invoice6.id)
      create(:transaction, invoice_id: @invoice7.id)
      create(:transaction, invoice_id: @invoice8.id)

      create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id)
      create(:invoice_item, invoice_id: @invoice2.id, item_id: @item3.id)
      create(:invoice_item, invoice_id: @invoice3.id, item_id: @item4.id)
      create(:invoice_item, invoice_id: @invoice4.id, item_id: @item1.id)
      create(:invoice_item, invoice_id: @invoice7.id, item_id: @item2.id)
      create(:invoice_item, invoice_id: @invoice8.id, item_id: @item3.id)
      create(:invoice_item, invoice_id: @invoice6.id, item_id: @item3.id)
      create(:invoice_item, invoice_id: @invoice5.id, item_id: @item4.id)
    end

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

    it 'should see the top 5 customers with successful transactions' do
      visit '/admin'

      within '.top-5-customers' do
        expect(page).to have_content('Top 5 Customers')
        expect(page).to have_content("#{@customer2.first_name} #{@customer2.last_name} - 3")
        expect(page).to have_content("#{@customer1.first_name} #{@customer1.last_name} - 2")
        expect(page).to have_content("#{@customer3.first_name} #{@customer3.last_name} - 1")
        expect(page).to have_content("#{@customer4.first_name} #{@customer4.last_name} - 1")
        expect(page).to have_content("#{@customer5.first_name} #{@customer5.last_name} - 1")
      end
    end
  end
end