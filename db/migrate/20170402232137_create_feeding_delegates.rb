class CreateFeedingDelegates < ActiveRecord::Migration[5.0]
  def change
    create_table :feeding_delegates do |t|
      t.references :feeding #, foreign_key: true, null: false # does not exist at the database
      t.float :amount
      t.string :foodItem
    end
  end
end
