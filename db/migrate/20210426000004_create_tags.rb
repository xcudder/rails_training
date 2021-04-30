class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.integer :tag_type_id, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_foreign_key :tags, :tag_types
  end
end
