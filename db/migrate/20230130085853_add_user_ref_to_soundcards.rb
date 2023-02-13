class AddUserRefToSoundcards < ActiveRecord::Migration[7.0]
  def change
    add_reference :soundcards, :user, null: false, foreign_key: true
  end
end
