class CreateMovements < ActiveRecord::Migration[6.0]
  def change
    create_table :movements do |t|
      t.references(:account, index: true)
      t.integer :operation
      t.monetize :amount

      t.timestamps
    end
  end
end
