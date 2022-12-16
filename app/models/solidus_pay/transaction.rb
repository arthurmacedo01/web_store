class SolidusPay::Transaction < Spree::PaymentSource
  self.table_name = "solidus_pay_transactions"

  # SolidusPay payments can be voided and refunded.
  def actions
    %w(void credit)
  end
  
  # We rely on the payment state machine to determine when a SolidusPay payment can be voided.
  def can_void?(payment)
    payment.can_void?
  end

  # A SolidusPay payment can be refunded if it's been captured and if the
  # un-refunded amount is greater than 0.
  def can_credit?(payment)
    payment.completed? && payment.credit_allowed > 0
  end

  # SolidusPay accounts can be used to pay on future orders as well.
  def reusable?
    true
  end
end