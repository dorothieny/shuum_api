class CreateStrikes < ActiveRecord::Migration[7.0]
  def change
    create_table :strikes do |t|
      t.references :soundcard, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
