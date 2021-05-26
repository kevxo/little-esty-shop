require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'class method methods' do
    before(:each) do
      @merchant = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)

      @customer1 = create(:customer)
      @customer2 = create(:customer)
      @customer3 = create(:customer)
      @customer4 = create(:customer)
      @customer5 = create(:customer)

      @item1 = create(:item, merchant_id: @merchant.id)
      @item2 = create(:item, merchant_id: @merchant.id)
      @item3 = create(:item, merchant_id: @merchant.id)
      @item4 = create(:item, merchant_id: @merchant.id)
      @item5 = create(:item, merchant_id: @merchant2.id)
      @item6 = create(:item, merchant_id: @merchant2.id)
      @item7 = create(:item, merchant_id: @merchant3.id)
      @item8 = create(:item, merchant_id: @merchant3.id)

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

    it 'top 5 customers with successful transactions' do
      expected = [
        "#{@customer2.first_name} #{@customer2.last_name} - 3",
        "#{@customer1.first_name} #{@customer1.last_name} - 2",
        "#{@customer3.first_name} #{@customer3.last_name} - 1",
        "#{@customer4.first_name} #{@customer4.last_name} - 1",
        "#{@customer5.first_name} #{@customer5.last_name} - 1"
      ]

      expect(Invoice.most_successful_transactions(@merchant.id)).to eq(expected)
    end

    it 'top 5 customers with successful transactions, with diffrent merchant' do
      expected = []

      expect(Invoice.most_successful_transactions(@merchant2.id)).to eq(expected)
    end

    it 'top 5 customers with no merchant id' do
      expected = [
        "#{@customer2.first_name} #{@customer2.last_name} - 3",
        "#{@customer1.first_name} #{@customer1.last_name} - 2",
        "#{@customer3.first_name} #{@customer3.last_name} - 1",
        "#{@customer4.first_name} #{@customer4.last_name} - 1",
        "#{@customer5.first_name} #{@customer5.last_name} - 1"
      ]
      expect(Invoice.top_5_customers).to eq(expected)
    end
  end

  describe 'Instance methods' do
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

      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice1.id, item_id: @item3.id, quantity: 3, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice3.id, item_id: @item4.id, quantity: 4, unit_price: 700)
      create(:invoice_item, invoice_id: @invoice4.id, item_id: @item1.id, quantity: 1, unit_price: 600)
      create(:invoice_item, invoice_id: @invoice7.id, item_id: @item2.id, status: 1, quantity: 5, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice8.id, item_id: @item3.id, status: 2, quantity: 2, unit_price: 500)
      create(:invoice_item, invoice_id: @invoice6.id, item_id: @item5.id, quantity: 3, unit_price: 100)
      create(:invoice_item, invoice_id: @invoice5.id, item_id: @item4.id, quantity: 3, unit_price: 200)
    end

    it 'should give total revenue of all items in one invoice' do
      expect(@invoice1.total_revenue).to eq('3,000')
      expect(@invoice2.total_revenue).to eq('0')
      expect(@invoice3.total_revenue).to eq('2,800')
      expect(@invoice4.total_revenue).to eq('600')
      expect(@invoice5.total_revenue).to eq('600')
      expect(@invoice6.total_revenue).to eq('300')
      expect(@invoice7.total_revenue).to eq('2,500')
      expect(@invoice8.total_revenue).to eq('1,000')
    end
  end
end
