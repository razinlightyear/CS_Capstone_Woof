class CreatePostEventDelegates < ActiveRecord::Migration[5.0]
  def change
    create_table :post_event_delegates do |t|
      t.text :description
      t.datetime :date_time
      t.boolean :private
      t.references :post_event #, foreign_key: true
    end
  end
end
