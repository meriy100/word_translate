class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :en
      t.string :ja
      t.integer :count
      t.boolean :hide
      t.timestamps null: false
    end
  end
end
