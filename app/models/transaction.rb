class Transaction < ApplicationRecord
  belongs_to :invoice

  enum result: %i[success failed]
end
