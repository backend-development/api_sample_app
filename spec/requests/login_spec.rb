# frozen_string_literal: true

# file /spec/requests/api_spec.rb

require 'swagger_helper'

RSpec.describe 'Stand Alone API', type: :request do
  describe 'Login' do
    fixtures :users
    before { @user = users(:mando) }
    path '/users/sign_in.json' do
      post 'log in as existing user, get jwt' do
        tags 'Login'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                password: { type: :string }
              },
              required: %w[email password]
            }
          }
        }

        response '201', 'user logged in' do
          let(:user) do
            u = User.first
            { user: { email: u.email, password: '12345678' } }
          end
          run_test!
          header 'Authorization', type: :string, description: 'new JWT'
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end

        response '401', 'login failed' do
          let(:user) do
            u = User.first
            { user: { email: u.email, password: 'wrong' } }
          end
          run_test!
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end
      end
    end
  end
end
