# frozen_string_literal: true
# file /spec/requests/api_spec.rb

require 'swagger_helper'

RSpec.describe 'Stand Alone API', type: :request do
  fixtures :users
  before { @user = users(:mando) }
  path '/api/v1/users' do
    get 'list all the users' do
      produces 'abpplication/json'

      response(200, 'successful') do
        schema type: :object,
            properties: {
                data: { 
                    type: :array,
                    items: {
                        type: :object, 
                        properties: {
                            id: { type: :string },
                            type: { type: :string },
                            attributes: { 
                                type: :object, 
                                properties: {
                                    name: { type: :string },
                                    email: { type: :string }
                                },
                                required: %w[name email]
                            }
                        },
                        required: %w[id type attributes]
                    }
                }
            }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    get 'show user' do
      produces 'application/json'
      parameter name: 'id', in: :path, type: :string

      response 200, 'successful' do
        schema type: :object,
            properties: {
                data: { 
                    type: :object, 
                    properties: {
                        id: { type: :string },
                        type: { type: :string },
                        attributes: { 
                            type: :object, 
                            properties: {
                                name: { type: :string },
                                email: { type: :string }
                            },
                            required: %w[name email]
                        }
                    },
                    required: %w[id type attributes]
                }
            }
        let(:id) do
          u = User.create!(name: 'Luke', email: 'luke@skywalker.net', password: '1234567', password_confirmation: '1234567')
          u.id
        end

        run_test!
      end
    end
  end
end
