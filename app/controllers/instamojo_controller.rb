class InstamojoController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :webhook

  # GET /instamojo/redirect?payment_request_id&payment_id
  def redirect
    payment = Payment.find_by instamojo_payment_request_id: params[:payment_request_id]
    payment.refresh_payment!(params[:payment_id])
    payment.perform_post_payment_tasks!

    redirect_to apply_continue_path(from: 'instamojo')
  end

  # POST /instamojo/webhook
  def webhook
    if authentic_request?
      payment = Payment.find_by instamojo_payment_request_id: params[:payment_request_id]

      update_params = {
        instamojo_payment_id: params[:payment_id],
        instamojo_payment_status: params[:status],
        fees: params[:fees],
        webhook_received_at: Time.now
      }

      update_params[:instamojo_payment_request_status] = 'Completed' if params[:status] == 'Credit'

      payment.update update_params
      payment.perform_post_payment_tasks!

      head :ok
    else
      head :unauthorized
    end
  end

  private

  def authentic_request?
    salt = Rails.application.secrets.instamojo_salt
    data = (params.keys - %w(controller action mac)).sort.map { |key| params[key] }.join '|'
    digest = OpenSSL::Digest.new('sha1')
    computed_mac = OpenSSL::HMAC.hexdigest(digest, salt, data)

    params[:mac] == computed_mac
  end
end
