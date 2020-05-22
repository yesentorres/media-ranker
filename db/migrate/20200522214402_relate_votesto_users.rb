class RelateVotestoUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :vote, index: true
  end
end
