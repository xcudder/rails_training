class Book < ApplicationRecord
    belongs_to :company
    belongs_to :category
    validates_associated :company
    validates_associated :category
    validates :author, length: { in: 3..30 }
    validates :description, length: { maximum: 200 }
end