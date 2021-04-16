class CreateBooks < ActiveRecord::Migration[5.2]
    def change
        create_table :books do |t|
            t.integer :category_id, null: false
            t.integer :company_id, null: false
            t.string :name, null: false
            t.string :editor
            t.string :author, null: false
            t.text :description, limit:250
            t.integer :price, null: false
            t.timestamps
        end

        add_foreign_key :books, :categories
        add_foreign_key :books, :companies
    end
end
