class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.references(:user, index: true)
      t.monetize :balance

      t.timestamps
    end
  end
end
