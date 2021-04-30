class Tag < ApplicationRecord
    belongs_to :tag_type
    has_and_belongs_to_many :employees
    validates_associated :tag_type, presence: true
    validates :name, presence: true, length: { minimum: 3 }
end