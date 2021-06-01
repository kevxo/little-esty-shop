require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I visit my merchant items index page' do
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

    it 'should see a list of all my items', :vcr do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      item3 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        expect(page).to have_content(item1.name)
        expect(page).to have_content(item2.name)
        expect(page).to have_content(item3.name)
      end
    end

    it 'should not see other merchants items', :vcr do
      merchant = create(:merchant)
      merchant2 = create(:merchant)

      item1 = create(:item, merchant_id: merchant2.id)
      item2 = create(:item, merchant_id: merchant2.id)
      item3 = create(:item, merchant_id: merchant2.id)

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        expect(page).to_not have_content(item1.name)
        expect(page).to_not have_content(item2.name)
        expect(page).to_not have_content(item3.name)
      end
    end

    it 'should see a button to disable or enable an Item', :vcr do
      merchant = create(:merchant)

      create(:item, merchant_id: merchant.id)
      create(:item, merchant_id: merchant.id, status: 'Disabled')
      create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        expect(page).to have_button('Disabled')
        expect(page).to have_button('Enabled')
        expect(page).to have_button('Disabled')
      end
    end

    it 'should change item status when clicking button from disabled to enabled', :vcr do
      merchant = create(:merchant)

      create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        click_button 'Disabled'
      end

      expect(current_path).to eq("/merchant/#{merchant.id}/items")

      within '.my-items' do
        expect(page).to have_button('Enabled')
      end
    end

    it 'should change item status when clicking button from enabled to disabled', :vcr do
      merchant = create(:merchant)

      create(:item, merchant_id: merchant.id, status: 'Disabled')

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        click_button 'Enabled'
      end

      expect(current_path).to eq("/merchant/#{merchant.id}/items")

      within '.my-items' do
        expect(page).to have_button('Disabled')
      end
    end

    it 'should see that enabled and disabled items have their own sections.', :vcr do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id, status: 'Disabled')
      item3 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items"

      expect(all('.enabled-items')[0]).to have_content(item1.name)
      expect(all('.disabled-items')[1]).to have_content(item2.name)
      expect(all('.enabled-items')[2]).to have_content(item3.name)
    end

    it 'should see link to create an Item and it should take me to  a form', :vcr do
      merchant = create(:merchant)

      create(:item, merchant_id: merchant.id)
      create(:item, merchant_id: merchant.id, status: 'Disabled')
      create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items"

      expect(page).to have_link('Create Item')

      click_link 'Create Item'

      expect(current_path).to eq("/merchant/#{merchant.id}/items/new")
      expect(page).to have_content('New Item')
    end

    it 'should see top 5 popular items by revenue generated', :vcr do
      visit "/merchant/#{@merchant.id}/items"

      expect(all('.top-5-popular')[0]).to have_content(@item3.name)
      expect(all('.top-5-popular')[1]).to have_content(@item1.name)
      expect(all('.top-5-popular')[2]).to have_content(@item4.name)
      expect(all('.top-5-popular')[3]).to have_content(@item2.name)
      expect(all('.top-5-popular')[-1]).to have_content(@item5.name)
    end
  end

  describe 'When I click on an item' do
    it 'should take me to the item show page and the items attributes', :vcr do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items"

      within '.my-items' do
        expect(page).to have_link(item1.name)

        click_link item1.name
      end

      expect(current_path).to eq("/merchant/#{merchant.id}/items/#{item1.id}")

      within '.item-info' do
        expect(page).to have_content("Name: #{item1.name}")
        expect(page).to have_content("Description: #{item1.description}")
        expect(page).to have_content("Current Selling Price: $#{item1.unit_price}")
      end
    end

    it 'should have a link to update an Item', :vcr do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items/#{item1.id}"

      expect(page).to have_link('Update Item')
      click_link 'Update Item'

      expect(current_path).to eq("/merchant/#{merchant.id}/items/#{item1.id}/edit")
    end

    it 'should fill out a form to update Item', :vcr do
      merchant = create(:merchant)

      item1 = create(:item, merchant_id: merchant.id)

      visit "/merchant/#{merchant.id}/items/#{item1.id}/edit"

      fill_in :name, with: 'Awesome Macboook Pro 2000'
      fill_in :description, with: 'Works great and there 3 in the whole world'
      fill_in :unit_price, with: 2000

      click_button 'Update'

      expect(current_path).to eq("/merchant/#{merchant.id}/items/#{item1.id}")
      expect(page).to have_content('Item has been updated successfully!')
    end
  end

  describe 'Create a new Item' do
    it 'should fill out item information and have a disabled as my default status', :vcr do
      merchant = create(:merchant)

      visit "/merchant/#{merchant.id}/items/new"

      fill_in :name, with: 'Macbook Pro 2000'
      fill_in :description, with: 'The new era of apple'
      fill_in :unit_price, with: 2500

      click_button 'Submit'

      expect(current_path).to eq("/merchant/#{merchant.id}/items")

      within '.my-items' do
        expect(page).to have_content('Macbook Pro 2000')
      end

      expect(page).to have_content('Item created successfully!')
      expect(all('.disabled-items')[0]).to have_content('Macbook Pro 2000')
    end
  end
end
