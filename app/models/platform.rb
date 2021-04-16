class Platform < ApplicationRecord
    has_many :games, dependent: :destroy
end