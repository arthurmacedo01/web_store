module SolidusPay
  class Gateway
    API_URL = 'https://api.mercadopago.com/v1'

    attr_reader :api_key

    def initialize(options)
      @api_key = options.fetch(:api_key)
    end

    def authorize(money, auth_token, options = {})
      response = request(
        :post,
        "/payments",
        payload_for_charge(money, auth_token, options),
      )

      options[:originator].source.qr_code = response.parsed_response['point_of_interaction']['transaction_data']['qr_code']
      options[:originator].source.qr_code_base64 = response.parsed_response['point_of_interaction']['transaction_data']['qr_code_base64']
      options[:originator].source.save!

      if response.success?        
        ActiveMerchant::Billing::Response.new(
          true,
          "Transaction Authorized",
          {},
          authorization: response.parsed_response['id'],
        )
      else
        ActiveMerchant::Billing::Response.new(
          false,
          response.parsed_response['error'],
        )
      end
    end

    def capture(money, transaction_id, options = {})
      ActiveMerchant::Billing::Response.new(true, "Transaction Captured")
    end

    def void(transaction_id, options = {})
      ActiveMerchant::Billing::Response.new(true, "Transaction Voided")
    end

    def credit(money, transaction_id, options = {})
      response = request(
        :post,
        "/payments/#{transaction_id}/refunds",
        { amount: money },
      )

      if response.success?
        ActiveMerchant::Billing::Response.new(true, "Transaction Credited")
      else
        ActiveMerchant::Billing::Response.new(
          false,
          response.parsed_response['error'],
        )
      end
      
    end       

    private

    def request(method, uri, body = {})
      HTTParty.send(method,
      "#{API_URL}#{uri}",
      headers: {
      "Authorization" => "Bearer #{api_key}",
      "Content-Type" => "application/json",
      "Accept" => "application/json",
      },
      body: body.to_json,
      )
    end

    def payload_for_charge(money, auth_token, options = {})
      {
        description: "Payment #{options[:order_id]}",
        transaction_amount: money,
        notification_url: "https://meu.site/notificacao_de_pagamento",
        payment_method_id: "pix",
        payer: {
          email: 'test@test.com'
        }        
      }
    end

  end
end