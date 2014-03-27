class Changeinfosmoneytype < ActiveRecord::Migration
  def change
    change_column :infos, :money, :double
  end
end
