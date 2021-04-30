class Employee < ApplicationRecord
    has_and_belongs_to_many :tags
    validates :name, presence: true, length: { minimum: 3 }
end