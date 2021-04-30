class TagType < ApplicationRecord
    has_many :tags, dependent: :destroy
    validates :name, presence: true, length: { minimum: 3 }
end