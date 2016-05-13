class CreateStocastics < ActiveRecord::Migration
  def change
    create_table :stocastics do |t|
      t.string :symbol
      t.float :price
      t.string :marketTime

      t.timestamps null: false
    end
  end
end
