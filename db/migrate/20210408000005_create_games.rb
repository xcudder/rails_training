class CreateGames < ActiveRecord::Migration[5.2]
    def change
        create_table :games do |t|
            t.integer :platform_id, null: false
            t.integer :company_id, null: false
            t.string :name, null: false
            t.text :description, limit:250
            t.integer :price, null: false
            t.timestamps
        end

        add_foreign_key :games, :platforms
        add_foreign_key :games, :companies
    end
end
