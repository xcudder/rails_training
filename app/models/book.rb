class Book < ApplicationRecord
    belongs_to :company
    belongs_to :category
    validates_associated :company, presence: true
    validates_associated :category, presence: true
    validates :author, length: { in: 3..30 }
    validates :description, length: { maximum: 200 }
    validates :price, presence: true
    validates :name, presence: true, length: { minimum: 3 }
end