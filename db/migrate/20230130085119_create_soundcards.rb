class CreateSoundcards < ActiveRecord::Migration[7.0]
  def change
    create_table :soundcards do |t|
      t.string :name
      t.string :description
      t.string :audiofile
      t.string :image
      t.string :location

      t.timestamps
    end
  end
end
