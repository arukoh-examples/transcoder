class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string  :name
      t.string  :mime_type
      t.integer :size
      t.string  :link
      t.string  :bucket
      t.string  :object_key

      t.timestamp :created_at
    end
    add_index :contents, :object_key, unique: true
  end
end
