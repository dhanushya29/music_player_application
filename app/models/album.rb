class Album < ApplicationRecord
	belongs_to :artist ,foreign_key: true
    has_many :songs 
    has_one :image ,as: :imageable
	validates :title,:language , presence: true
end
