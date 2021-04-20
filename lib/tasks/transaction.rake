require 'csv'

namespace :csv_load do
  desc 'Loads transactions csv file'
  task transactions: :environment do
    csv_text = File.read('./db/data/transactions.csv')
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      row['result'] = if row['result'] == 'success'
                        0
                      else
                        1
                      end

      Transaction.create!(row.to_hash)
    end
  end
end
