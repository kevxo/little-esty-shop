require 'csv'

namespace :csv_load do
  desc 'Loads invoice items csv file'
  task invoice_items: :environment do
    csv_text = File.read('./db/data/invoice_items.csv')
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      row['status'] = if row['status'] == 'packaged'
                        0
                      elsif row['status'] == 'shipped'
                        1
                      else
                        2
                      end
      InvoiceItem.create!(row.to_hash)
    end
  end
end
