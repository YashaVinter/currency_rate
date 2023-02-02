class CreateAdminRates < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_rates do |t|
      t.integer :end_timestamp
      t.references :dollar_rate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
