class CreateFeedingHistoryDelegates < ActiveRecord::Migration[5.0]
  def change
    create_table :feeding_history_delegates do |t|
      t.references :feeding_history #, foreign_key: true, null: false # does not exist at the database
      t.float :amount
      t.string :food_item
    end
  end
end
