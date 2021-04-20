require 'csv'

namespace :csv_load do
  desc 'Loads items csv file'
  task items: :environment do
    csv_text = File.read('./db/data/items.csv')
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      Item.create!(row.to_hash)
    end
  end
end