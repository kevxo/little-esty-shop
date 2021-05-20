require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with(%i[Enabled Disabled]) }
  end

  describe 'class method methods' do
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

    it '.ready to ship items' do
      expect(@item1.ready_to_ship.length).to eq(1)
      expect(@item2.ready_to_ship.length).to eq(0)
      expect(@item3.ready_to_ship.length).to eq(1)
      expect(@item4.ready_to_ship.length).to eq(2)
      expect(@item5.ready_to_ship.length).to eq(1)
    end

    it 'top 5 most popular items by revenue' do
      items  = Item.most_popular_items(@merchant.id)
      expect(items.first.name).to eq(@item3.name)
      expect(items.second.name).to eq(@item1.name)
      expect(items.third.name).to eq(@item4.name)
      expect(items.fourth.name).to eq(@item2.name)
      expect(items.last.name).to eq(@item5.name)
      expect(Item.most_popular_items(@merchant.id).length).to eq(5)
    end

    it 'top 5 merchants' do
      merchant1 = create(:merchant, name: 'John')
      merchant2 = create(:merchant, name: 'Danny')
      merchant3 = create(:merchant, name: 'Oscar')
      merchant4 = create(:merchant, name: 'Tony')
      merchant5 = create(:merchant, name: 'Paul')

      customer1 = create(:customer)
      customer2 = create(:customer)
      customer3 = create(:customer)
      customer4 = create(:customer)
      customer5 = create(:customer)

      item1 = create(:item, merchant_id: merchant1.id, name: 'Small Wooden Table')
      item2 = create(:item, merchant_id: merchant2.id, name: 'Practical Paper Keyboard')
      item3 = create(:item, merchant_id: merchant3.id, name: 'Gorgeous Bronze Bottle')
      item4 = create(:item, merchant_id: merchant4.id, name: 'Synergistic Linen Keyboard')
      item5 = create(:item, merchant_id: merchant5.id, name: 'Small Cotton Pants')

      invoice1 = create(:invoice, customer_id: customer1.id)
      invoice2 = create(:invoice, customer_id: customer1.id)
      invoice3 = create(:invoice, customer_id: customer2.id)
      invoice4 = create(:invoice, customer_id: customer2.id)
      invoice5 = create(:invoice, customer_id: customer2.id)
      invoice6 = create(:invoice, customer_id: customer3.id)
      invoice7 = create(:invoice, customer_id: customer4.id)
      invoice8 = create(:invoice, customer_id: customer5.id)

      create(:transaction, invoice_id: invoice1.id)
      create(:transaction, invoice_id: invoice2.id)
      create(:transaction, invoice_id: invoice3.id)
      create(:transaction, invoice_id: invoice4.id)
      create(:transaction, invoice_id: invoice5.id)
      create(:transaction, invoice_id: invoice6.id)
      create(:transaction, invoice_id: invoice7.id)
      create(:transaction, invoice_id: invoice8.id)

      create(:invoice_item, invoice_id: invoice1.id, item_id: item1.id, status: 1, quantity: 3, unit_price: 700)
      create(:invoice_item, invoice_id: invoice2.id, item_id: item3.id, quantity: 3, unit_price: 200)
      create(:invoice_item, invoice_id: invoice3.id, item_id: item4.id, quantity: 3, unit_price: 900)
      create(:invoice_item, invoice_id: invoice4.id, item_id: item1.id, quantity: 3, unit_price: 200)
      create(:invoice_item, invoice_id: invoice7.id, item_id: item2.id, quantity: 3, unit_price: 100)
      create(:invoice_item, invoice_id: invoice8.id, item_id: item3.id, quantity: 3, unit_price: 200)
      create(:invoice_item, invoice_id: invoice6.id, item_id: item5.id, quantity: 3, unit_price: 300)
      create(:invoice_item, invoice_id: invoice5.id, item_id: item4.id, quantity: 3, unit_price: 500)

      expected = {
        merchant4.name => 8400,
        @merchant.name => 6000,
        @merchant.name => 6000,
        @merchant.name => 6000,
        merchant1.name => 5400
      }

      expect(Item.top_merchants).to eq(expected)
    end
  end
end
