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

      create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1)
      create(:invoice_item, invoice_id: @invoice2.id, item_id: @item3.id)
      create(:invoice_item, invoice_id: @invoice3.id, item_id: @item4.id)
      create(:invoice_item, invoice_id: @invoice4.id, item_id: @item1.id)
      create(:invoice_item, invoice_id: @invoice7.id, item_id: @item2.id, status: 1)
      create(:invoice_item, invoice_id: @invoice8.id, item_id: @item3.id, status: 2)
      create(:invoice_item, invoice_id: @invoice6.id, item_id: @item3.id)
      create(:invoice_item, invoice_id: @invoice5.id, item_id: @item4.id)
    end

    it '.ready to ship items' do
      expect(@item1.ready_to_ship.length).to eq(1)
      expect(@item2.ready_to_ship.length).to eq(0)
      expect(@item3.ready_to_ship.length).to eq(2)
      expect(@item4.ready_to_ship.length).to eq(2)
      expect(@item5.ready_to_ship.length).to eq(0)
    end
  end
end
