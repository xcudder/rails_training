class Company < ApplicationRecord
    has_many :books, dependent: :destroy
    has_many :games, dependent: :destroy
end