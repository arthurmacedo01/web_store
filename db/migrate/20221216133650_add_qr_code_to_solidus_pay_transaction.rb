class AddQrCodeToSolidusPayTransaction < ActiveRecord::Migration[6.1]
  def change
    add_column :solidus_pay_transactions, :qr_code, :string
    add_column :solidus_pay_transactions, :qr_code_base64, :string
  end
end
