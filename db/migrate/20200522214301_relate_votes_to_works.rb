class RelateVotesToWorks < ActiveRecord::Migration[6.0]
  def change
    add_reference :works, :vote, index: true
  end
end
