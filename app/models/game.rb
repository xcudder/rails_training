class Game < ApplicationRecord
    belongs_to :company
    belongs_to :platform
    validates_associated :company
    validates_associated :platform
    validates :description, length: { maximum: 200 }
end