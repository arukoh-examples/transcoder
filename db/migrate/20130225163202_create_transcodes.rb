class CreateTranscodes < ActiveRecord::Migration
  def change
    create_table :transcodes do |t|
      t.integer :content_id
      t.string :job_id
      t.string :preset_id
      t.text :preset_detail
      t.string :bucket
      t.string :object_key
      t.string :thumbnail_key_prefix
      t.timestamp :created_at
    end
    add_index :transcodes, [ :content_id, :job_id ]
  end
end
