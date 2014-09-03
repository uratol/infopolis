class CreateUserMasters < ActiveRecord::Migration
  def change
    create_table :user_masters do |t|
      t.integer :user_id, null: false
      t.integer :master_id, null: false

      t.timestamps
    end
    
    add_index :user_masters, [:user_id, :master_id], unique: true
    add_index :user_masters, :master_id
  end
end
