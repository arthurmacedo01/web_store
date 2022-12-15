FactoryBot.define do
  factory :solidus_pay_transaction, class: 'SolidusPay::Transaction' do
    payment_method_id { 1 }
    auth_token { "MyString" }
  end
end
