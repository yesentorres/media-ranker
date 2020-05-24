class AddForeignKeys < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :votes, :users
    add_foreign_key :votes, :works
  end
end
