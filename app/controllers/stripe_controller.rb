class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhooks
    event = nil
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.stripe[:webhook_key]
    return render json: { msg: 'missing headers' } unless sig_header

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      return render json: { message: e }, status: :bad_request
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      return render json: { message: e }, status: :bad_request
    end

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      puts 'PaymentIntent was succeeded'
    when 'payment_method.attached'
      puts 'PaymentMethod was attached to a Customer!'
    else
      puts "Unhandled event type: #{event.type}"
    end
    # stuff here
    File.open(Rails.root.join("spec/fixtures/#{event.type}.yml"), 'w') do |f|
      f.write event.data.object.as_json.to_yaml
    end
  end

  def create_checkout_session
    response.headers['Access-Control-Allow-Origin'] = 'checkout.stripe.com'
    # response.headers['Access-Control-Allow-Origin'] = '*'
    render json: { session_id: Stripe::Checkout::Session.create({
                                                                  line_items: [{
                                                                    price: params[:priceId],
                                                                    quantity: 1
                                                                  }],
                                                                  mode: 'payment',
                                                                  success_url: "#{ENV['HOST']}/stripe/success",
                                                                  cancel_url: "#{ENV['HOST']}/stripe/cancel"
                                                                }).id }
  end

  def success
    payload = request.body.read

    File.open(Rails.root.join('spec/fixtures/stripe/success.yml'), 'w') do |f|
      f.write payload.as_json.to_yaml
    end
  end

  def failure
    payload = request.body.read
    File.open(Rails.root.join('spec/fixtures/stripe/failure.yml'), 'w') do |f|
      f.write payload.as_json.to_yaml
    end
  end
end
