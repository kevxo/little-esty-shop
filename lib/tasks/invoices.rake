require 'csv'

namespace :csv_load do
  desc 'Loads invoices csv file'
  task invoices: :environment do
    csv_text = File.read('./db/data/invoices.csv')
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      Invoice.create!(row.to_hash)
    end
  end
end