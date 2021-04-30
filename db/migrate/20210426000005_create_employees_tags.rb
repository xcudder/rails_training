class CreateEmployeesTags < ActiveRecord::Migration[5.2]
  def change
    create_join_table :employees, :tags do |t|
      t.index :employee_id
      t.index :tag_id
    end
  end
end
