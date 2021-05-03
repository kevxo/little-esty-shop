require 'rails_helper'

RSpec.describe 'As a Merchant' do
  describe 'When I visit Merchant invoices index page' do
    before(:each) do
      @merchant = create(:merchant)

      @customer1 = create(:customer)
      @customer2 = create(:customer)
      @customer3 = create(:customer)
      @customer4 = create(:customer)
      @customer5 = create(:customer)

      @item1 = create(:item, merchant_id: @merchant.id, name: 'Small Wooden Table')
      @item2 = create(:item, merchant_id: @merchant.id, name: 'Practical Paper Keyboard')
      @item3 = create(:item, merchant_id: @merchant.id, name: 'Gorgeous Bronze Bottle')
      @item4 = create(:item, merchant_id: @merchant.id, name: 'Synergistic Linen Keyboard')
      @item5 = create(:item, merchant_id: @merchant.id, name: 'Small Cotton Pants')

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

      create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice2.id, item_id: @item3.id, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice3.id, item_id: @item4.id, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice4.id, item_id: @item1.id, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice7.id, item_id: @item2.id, status: 1, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice8.id, item_id: @item3.id, status: 2, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice6.id, item_id: @item5.id, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice5.id, item_id: @item4.id, quantity: 3, unit_price: 500)
    end

    it 'should see the invoices that include at least one of my merchants item' do
      visit "/merchant/#{@merchant.id}/invoices"

      expect(page).to have_content('Invoices')

      within '.my-invoices' do
        expect(page).to have_link(@invoice1.id)
        expect(page).to have_link(@invoice2.id)
        expect(page).to have_link(@invoice3.id)
        expect(page).to have_link(@invoice4.id)
        expect(page).to have_link(@invoice5.id)
        expect(page).to have_link(@invoice6.id)
        expect(page).to have_link(@invoice7.id)
        expect(page).to have_link(@invoice8.id)

        click_link @invoice1.id
      end

      expect(current_path).to eq("/merchant/#{@merchant.id}/invoices/#{@invoice1.id}")
    end
  end
end