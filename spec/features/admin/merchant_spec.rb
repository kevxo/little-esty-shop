require 'rails_helper'

RSpec.describe 'As a admin' do
  describe 'When I visit the admin merchants index page' do
    before(:each) do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant, status: 1)
      @merchant3 = create(:merchant)
      @merchant4 = create(:merchant, status: 1)
      @merchant5 = create(:merchant)
    end

    it 'should see the name of each merchant in the system' do
      visit '/admin/merchants'

      within '.all-merchants' do
        expect(page).to have_content(@merchant1.name)
        expect(page).to have_content(@merchant2.name)
        expect(page).to have_content(@merchant3.name)
        expect(page).to have_content(@merchant4.name)
        expect(page).to have_content(@merchant5.name)
      end
    end

    it 'should click on name and be directed to the merchant show page' do
      visit '/admin/merchants'

      within '.all-merchants' do
        expect(page).to have_link(@merchant1.name)

        click_link @merchant1.name
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")
      expect(page).to have_content(@merchant1.name)
      expect(page).to_not have_content(@merchant2.name)
    end

    it 'should see a button to enable or disable a merchant and update the merchants status' do
      visit '/admin/merchants'

      within ".merchant-#{@merchant1.id}" do
        expect(page).to have_button('Disable')

        click_button 'Disable'
      end

      expect(current_path).to eq('/admin/merchants')
    end

    it 'should see a link to create a new merchant and when I click be redirected to a form' do
      visit '/admin/merchants'

      expect(page).to have_link('Create a new Merchant')

      click_link 'Create a new Merchant'
      expect(current_path).to eq('/admin/merchants/new')

      fill_in :name, with: 'Kevin Cuadros'

      click_button 'Submit'

      expect(current_path).to eq('/admin/merchants')

      within '.all-merchants' do
        expect(page).to have_content('Kevin Cuadros')
      end
    end

    it 'should see the top 5 merchants by total revenue and each name links to their show page' do
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

      create(:invoice_item, invoice_id: invoice1.id, item_id: item1.id, quantity: 3, unit_price: 700)
      create(:invoice_item, invoice_id: invoice2.id, item_id: item3.id, quantity: 3, unit_price: 200)
      create(:invoice_item, invoice_id: invoice3.id, item_id: item4.id, quantity: 3, unit_price: 900)
      create(:invoice_item, invoice_id: invoice4.id, item_id: item1.id, quantity: 3, unit_price: 200)
      create(:invoice_item, invoice_id: invoice7.id, item_id: item2.id, quantity: 3, unit_price: 100)
      create(:invoice_item, invoice_id: invoice8.id, item_id: item3.id, quantity: 3, unit_price: 200)
      create(:invoice_item, invoice_id: invoice6.id, item_id: item5.id, quantity: 3, unit_price: 300)
      create(:invoice_item, invoice_id: invoice5.id, item_id: item4.id, quantity: 3, unit_price: 500)
      visit '/admin/merchants'

      within '.top-5-merchants' do
        expect(page).to have_link(merchant4.name)
        expect(page).to have_content("#{merchant4.name}-$8400")
        expect(page).to have_content("#{merchant1.name}-$5400")
        expect(page).to have_content("#{merchant3.name}-$2400")
        expect(page).to have_content("#{merchant5.name}-$900")
        expect(page).to have_content("#{merchant2.name}-$300")
      end
    end
  end

  describe 'When I visit the merchants show page' do
    it 'should see a link to update the merchant and see a flash message after update' do
      merchant = create(:merchant)

      visit "/admin/merchants/#{merchant.id}"

      expect(page).to have_link('Update Merchant')

      click_link 'Update Merchant'

      expect(current_path).to eq("/admin/merchants/#{merchant.id}/edit")

      fill_in :name, with: 'Kevin Cuadros'

      click_button 'Submit'

      expect(current_path).to eq("/admin/merchants/#{merchant.id}")
      expect(page).to have_content('Kevin Cuadros')
      expect(page).to have_content('Information has been successfully updated!')
    end
  end
end
