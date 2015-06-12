class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :en
      t.string :ja
      t.integer :count
      t.boolean :hide
      t.timestamps null:false
    end
  
  end
end
