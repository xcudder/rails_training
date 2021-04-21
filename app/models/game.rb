class Game < ApplicationRecord
    belongs_to :company
    belongs_to :platform
    validates_associated :company, presence: true
    validates_associated :platform, presence: true
    validates :description, length: { maximum: 200 }
    validates :price, presence: true
end