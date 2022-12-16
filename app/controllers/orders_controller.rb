# frozen_string_literal: true

class OrdersController < StoreController
  helper 'spree/products', 'orders'

  respond_to :html

  before_action :store_guest_token

  def show
    @order = Spree::Order.find_by!(number: params[:id])
    authorize! :show, @order, cookies.signed[:guest_token]    
    if( get_payment_type == "SolidusPay::Transaction")
      get_qr_codes
    end
  end

  private

  def accurate_title
    t('spree.order_number', number: @order.number)
  end

  def store_guest_token
    cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
  end

  def get_payment_type
    Spree::Payment.find_by(order_id: @order[:id], state: "pending")[:source_type]
  end

  def get_qr_codes 
    transaction_id = Spree::Payment.where(order_id: 30, state: "pending").first[:source_id]
    transaction = SolidusPay::Transaction.find(transaction_id)
    @qr_code = transaction[:qr_code]
    @qr_code_base64 = transaction[:qr_code_base64]
  end
end
