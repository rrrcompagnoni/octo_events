module WebhookAuthHelper
  def valid_signature?(payload, signature)
    Rack::Utils.secure_compare(generate_internal_signature(payload), signature)
  end

  def generate_internal_signature(payload)
    'sha256=' + OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha256'),
      ENV['ISSUES_EVENTS_WEBHOOK_SECRET'],
      payload
    )
  end
end
