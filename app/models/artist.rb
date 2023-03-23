class Artist < ApplicationRecord
	has_many :albums
    has_one :image ,as: :imageable
    validates :name,:region ,presence: true
end
