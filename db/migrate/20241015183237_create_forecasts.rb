class CreateForecasts < ActiveRecord::Migration[7.2]
  def change
    create_table :forecasts do |t|
      t.string :address
      t.string :address_hash
      t.jsonb :data
      t.datetime :expires_at

      t.timestamps
    end
    add_index :forecasts, :address_hash
  end
end
