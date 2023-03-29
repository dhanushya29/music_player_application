class Artist < ApplicationRecord
	has_many :albums ,foreign_key: true
    has_many :songs
    has_one :image ,as: :imageable
    validates :name,:region ,presence: true
end
