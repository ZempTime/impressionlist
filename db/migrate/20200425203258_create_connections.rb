class CreateConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.integer :status
      t.datetime :one_treasured_at, null: true
      t.datetime :two_treasured_at, null: true
      t.text :log, null: true

      t.timestamps
    end

    add_reference :connections, :user_one, foreign_key: {to_table: :users} 
    add_reference :connections, :user_two, foreign_key: {to_table: :users} 
  end
end
