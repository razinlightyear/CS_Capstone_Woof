class CreateWalkingPartners < ActiveRecord::Migration[5.0]
  def change
    create_table :walking_partners do |t|
      t.text :description
      t.timestamps
    end
  end
end
