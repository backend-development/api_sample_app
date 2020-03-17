Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/*', headers: :any, methods: :get
  end

  allow do
    origins 'localhost:3000', '127.0.0.1:3000', 'https://my-frontend.org'
    resource '/api/v1/*',
      methods: %i(get post put patch delete options head)
  end
end
