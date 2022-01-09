desc 'Trigger for dev'

task :trigger_payment do
  `stripe trigger payment_intent.succeeded` if Rails.env.development?
end
