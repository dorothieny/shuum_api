class Taggable < ApplicationRecord
  belongs_to :soundcard
  belongs_to :tag
end
