class CreateWalkingPartnerDelegates < ActiveRecord::Migration[5.0]
  def change
    create_table :walking_partner_delegates do |t|
      t.references :walking_partner #, foreign_key: true, null: false # does not exist at the database level
      t.text :description
    end
  end
end
