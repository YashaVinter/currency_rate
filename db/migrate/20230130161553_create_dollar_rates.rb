class CreateDollarRates < ActiveRecord::Migration[7.0]
  def change
    create_table :dollar_rates do |t|
      t.decimal :rate
      t.integer :timestamp

      t.timestamps
    end
  end
end
