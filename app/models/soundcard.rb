class Soundcard < ApplicationRecord
    belongs_to :user

    mount_uploader :image, SoundcardImageUploader
    mount_uploader :audiofile, SoundUploader
    has_many :likes, dependent: :destroy
    has_many :users, through: :likes
    has_many :taggables, dependent: :destroy
    has_many :tags, through: :taggables

    scope :filter_by_starts_with, -> (name) { where("name like ?", "%#{name}%")}
    scope :filter_by_location, -> (location) { where("location like ?", "%#{location}%")}
    scope :filter_by_multiple, -> (string) {Soundcard.joins(:tags).where("name like ? OR location like ? OR tags.tagname like ?", "%#{string}%", "%#{string}%", "%#{string}%")}

end
