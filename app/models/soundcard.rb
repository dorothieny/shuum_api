class Soundcard < ApplicationRecord
    belongs_to :user

    mount_uploader :image, SoundcardImageUploader
    mount_uploader :audiofile, SoundUploader
    has_many :likes, dependent: :destroy
    has_many :users, through: :likes
    has_many :taggables, dependent: :destroy
    has_many :tags, through: :taggables

    has_many :strikes, dependent: :destroy

    scope :filter_by_starts_with, -> (name) { where("name like ?", "%#{name}%")}
    scope :filter_by_location, -> (location) { where("location like ?", "%#{location}%")}
    scope :filter_by_multiple, -> (string) {Soundcard.joins(:tags).where("lower(name) like ? OR lower(location) like ? OR lower(tags.tagname) like ?", "%#{string}%", "%#{string}%", "%#{string}%").distinct}
    scope :filter_by_user, -> (user) { where user_id: user }

end
