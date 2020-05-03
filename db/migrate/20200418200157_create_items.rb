class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :link
      t.string :note, null: true
      t.integer :visibility, default: 0
      t.datetime :gifted_at, null: true
      t.references :list, foreign_key: true

      t.timestamps
    end
  end
end
