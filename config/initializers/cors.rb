Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    resource '/issues/events', headers: 'X-Hub-Signature-256', methods: [:post]
  end
end
