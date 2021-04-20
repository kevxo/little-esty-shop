require 'csv'

namespace :csv_load do
  desc 'Loads merchants csv file'
  task merchants: :environment do
    csv_text = File.read('./db/data/merchants.csv')
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      Merchant.create!(row.to_hash)
    end
  end
end