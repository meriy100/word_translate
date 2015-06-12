class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :title
      t.string :url
      t.string :tag
      t.timestamps null:false
    end
  
  end
end
