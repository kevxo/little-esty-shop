require 'rails_helper'

RSpec.describe 'As a Admin' do
  describe 'When I visit the admin Invoices Index' do
    it 'should see a list of Ivoice ids that link to invoice show page', :vcr do
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

  describe 'When I visit the invoice show page' do
    it 'should see all of the invoice information including the customer full name', :vcr do
      customer = create(:customer)
      invoice1 = create(:invoice, customer_id: customer.id)

      visit "/admin/invoices/#{invoice1.id}"

      within '.invoice-info' do
        expect(page).to have_content(invoice1.id)
        expect(page).to have_content(invoice1.status)
        expect(page).to have_content(invoice1.created_at.strftime('%A %B %d, %Y'))
        expect(page).to have_content("#{customer.first_name} #{customer.last_name}")
      end
    end

    it 'should see all the items in the invoice with name, quantity, price, and status', :vcr do
      merchant = create(:merchant)
      customer = create(:customer)

      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      item3 = create(:item, merchant_id: merchant.id)

      invoice = create(:invoice, customer_id: customer.id)

      create(:invoice_item, item_id: item1.id, invoice_id: invoice.id)
      create(:invoice_item, item_id: item2.id, invoice_id: invoice.id)
      create(:invoice_item, item_id: item3.id, invoice_id: invoice.id)

      visit "/admin/invoices/#{invoice.id}"

      invoice.invoice_items.each do |invoice_item|
        invoice.items.each do |item|
          within ".item-#{item.id}-#{invoice_item.id}" do
            expect(page).to have_content(item.name)
            expect(page).to have_content(invoice_item.quantity)
            expect(page).to have_content(invoice_item.unit_price)
          end

          within "#status-#{item.id}-#{invoice_item.id}" do
            expect(page).to have_content('Invoice Item Status: packaged pending shipped')
          end
        end
      end
    end

    it 'should see the total revenue generated from the invoice', :vcr do
      merchant = create(:merchant)
      customer = create(:customer)

      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      item3 = create(:item, merchant_id: merchant.id)

      invoice = create(:invoice, customer_id: customer.id)

      create(:invoice_item, item_id: item1.id, invoice_id: invoice.id)
      create(:invoice_item, item_id: item2.id, invoice_id: invoice.id)
      create(:invoice_item, item_id: item3.id, invoice_id: invoice.id)

      visit "/admin/invoices/#{invoice.id}"

      expect(page).to have_content("Total Revenue $#{invoice.total_revenue}")
    end

    it 'should update invoice status', :vcr do
      merchant = create(:merchant)
      customer = create(:customer)

      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      item3 = create(:item, merchant_id: merchant.id)

      invoice = create(:invoice, customer_id: customer.id)

      create(:invoice_item, item_id: item1.id, invoice_id: invoice.id)
      create(:invoice_item, item_id: item2.id, invoice_id: invoice.id)
      create(:invoice_item, item_id: item3.id, invoice_id: invoice.id)

      visit "/admin/invoices/#{invoice.id}"

      invoice.invoice_items.each do |invoice_item|
        invoice.items.each do |item|
          within "#status-#{item.id}-#{invoice_item.id}" do
            select 'packaged', from: 'status'

            click_button 'Update Item Status'
          end
        end
      end

      expect(current_path).to eq("/admin/invoices/#{invoice.id}")
    end
  end
end
