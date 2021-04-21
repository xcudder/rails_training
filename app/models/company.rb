class Company < ApplicationRecord
    has_many :books, dependent: :destroy
    has_many :games, dependent: :destroy
    validates :name, presence: true, length: { minimum: 3 }
end