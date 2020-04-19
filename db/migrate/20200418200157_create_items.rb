class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.integer :list_id
      t.string :name
      t.string :link
      t.string :note, null: true
      t.integer :visibility, default: 0
      t.datetime :gifted_at, null: true

      t.timestamps
    end
  end
end
