class Tag < ApplicationRecord
    has_many :taggables, dependent: :destroy
    has_many :soundcards, through: :taggables

    scope :filter_by_starts_with, -> (tagname) { where("tagname like ?", "%#{tagname}%")}
end
