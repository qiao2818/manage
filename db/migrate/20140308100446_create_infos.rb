class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.integer :user_id
      t.integer :money
      t.datetime :date
      t.text :address

      t.timestamps
    end
  end
end
