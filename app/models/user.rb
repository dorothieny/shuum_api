  class User < ApplicationRecord
    devise :database_authenticatable,
           :jwt_authenticatable,
           :registerable,
           jwt_revocation_strategy: JwtDenylist

           has_many :likes, dependent: :destroy
           has_many :liked_soundcards, :through => :likes, :source => :soundcard
           
           has_many :strikes, dependent: :destroy

           mount_uploader :avatar, AvatarUploader
           has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
           has_many :followees, through: :followed_users
           has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
           has_many :followers, through: :following_users

           scope :filter_by_starts_with, -> (name) { where("name like ?", "%#{name}%")}
  end
