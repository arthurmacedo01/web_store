class CreateSolidusPayTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :solidus_pay_transactions do |t|
      t.integer :payment_method_id
      t.string :auth_token

      t.timestamps
    end
  end
end
