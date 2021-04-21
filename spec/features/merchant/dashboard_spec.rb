require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As a merchant' do
    describe 'When I visit my merchant dashboard' do
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

      it 'should see the name of my merchant' do
        merchant = create(:merchant)

        visit "/merchant/#{merchant.id}/dashboard"

        expect(page).to have_content(merchant.name)
      end

      it 'should see links to items index and invoices index' do
        merchant = create(:merchant)

        visit "merchant/#{merchant.id}/dashboard"

        within '.links' do
          expect(page).to have_link('Items')
          expect(page).to have_link('Invoices')
        end
      end

      it 'should see top 5 customers with successful transactions with merchant ' do
        visit "/merchant/#{@merchant.id}/dashboard"

        within '.top-5-customers' do
          expect(page).to have_content('Top 5 Customers')
        end
      end
    end
  end
end
