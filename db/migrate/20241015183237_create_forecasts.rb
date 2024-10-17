class CreateForecasts < ActiveRecord::Migration[7.2]
  def change
    create_table :forecasts do |t|
      t.string :address
      t.string :zipcode
      t.jsonb :data

      t.timestamps
    end
    add_index :forecasts, :zipcode
  end
end
