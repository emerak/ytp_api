class CreateExternalAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :external_accounts do |t|
      t.references(:user, index: true)
      t.string :clabe
      t.monetize :balance
      t.timestamps
    end
  end
end
