class CreateTagTypes < ActiveRecord::Migration[5.2]
  def up
    create_table :tag_types do |t|
      t.string :name, null: false
      t.timestamps
    end

    TagType.create  [{name: 'project'}, {name: 'country'}, {name: 'role'}]
  end

  def down
    drop_table :tag_types
  end
end
