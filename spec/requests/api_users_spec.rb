# frozen_string_literal: true

# file /spec/requests/api_spec.rb

require 'swagger_helper'

RSpec.describe 'Stand Alone API', type: :request do
  describe 'Users' do
    fixtures :users
    before { @user = users(:mando) }
    path '/api/v1/users' do
      get 'list all the users' do
        tags 'User'
        produces 'application/json'
        security [Bearer: {}]
        response(200, 'successful') do
          let(:Authorization) { "Bearer #{token_for(@user)}" }
          schema type: :object,
                 properties: {
                   data: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :string },
                         type: { type: :string, enum: ['user'] },
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
        response '401', 'wrong token no data' do
          let(:Authorization) { 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c' }
          run_test!
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end
      end

      # echtes json:api
      #  curl -X POST "http://localhost:3000/api/v1/users/" \
      #  -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json'  \
      #     --data "{\"data\":{\"type\":\"user\",\"attributes\":{\"name\":\"Ember\",\"email\":\"ember@hier.com\",\"password\":\"geheim\"}}}"

      post 'Creates a user' do
        tags 'User'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :user,
                  in: :body,
                  schema: {
                    type: :object,
                    properties: {
                      data: {
                        type: :object,
                        properties: {
                          type: { type: :string, enum: ['user'] },
                          attributes: {
                            type: :object,
                            properties: {
                              name: { type: :string },
                              email: { type: :string },
                              password: { type: :string }
                            },
                            required: %w[name email password]
                          }
                        }
                      }
                    }
                  }
        # Rails Style
        # parameter name: :user,
        #           in: :body,
        #           schema: {
        #             type: :object,
        #             properties: {
        #               user: {
        #                 type: :object,
        #                 properties: {
        #                   name: { type: :string },
        #                   email: { type: :string },
        #                   password: { type: :string }
        #                 },
        #                 required: %w[name email password]
        #               }
        #             }
        #           }

        response '201', 'user created' do
          let(:Authorization) { "Bearer #{token_for(@user)}" }
          let(:user) do
            { data: { type: 'user', attributes: { name: 'Good', email: 'good@hier.com', password: 'asecret' } } }
          end
          run_test!
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end

        response '422', "password can't be blank, name can't exist, e-mail can't exist" do
          let(:Authorization) { "Bearer #{token_for(@user)}" }
          let(:user) do
            u = User.first
            { data: { type: 'user', attributes: { name: u.name, email: u.email } } }
          end
          run_test!
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end
      end
    end

    path '/api/v1/users/{id}' do
      get 'show user' do
        tags 'User'
        security [Bearer: {}]

        produces 'application/json'
        parameter name: 'id', in: :path, type: :string

        response 200, 'successful' do
          let(:Authorization) { "Bearer #{token_for(@user)}" }

          schema type: :object,
                 properties: {
                   data: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       type: { type: :string, enum: ['user'] },
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
      patch 'Updates a users data' do
        tags 'User'
        security [Bearer: {}]

        consumes 'application/json'
        produces 'application/json'
        parameter name: 'id', in: :path, type: :string
        parameter name: :user,
                  in: :body,
                  schema: {
                    type: :object,
                    properties: {
                      data: {
                        type: :object,
                        properties: {
                          type: { type: :string, enum: ['user'] },
                          id: { type: :string },
                          attributes: {
                            type: :object,
                            properties: {
                              name: { type: :string },
                              email: { type: :string },
                              password: { type: :string }
                            },
                            required: %w[name email password]
                          }
                        }
                      }
                    }
                  }
        # # rails style
        # parameter name: :user,
        #           in: :body,
        #           schema: {
        #             type: :object,
        #             properties: {
        #               data: {
        #                 type: :object,
        #                 properties: {
        #                   type: { type: :string, enum: ['user'] },
        #                   attributes: {
        #                     type: :object,
        #                     properties: {
        #                       name: { type: :string },
        #                       email: { type: :string },
        #                       password: { type: :string }
        #                     },
        #                     required: %w[name email password]
        #                   }
        #                 }
        #               }
        #             }
        #           }

        response '200', 'user updated: Raider heisst jetzt Twix' do
          let(:Authorization) { "Bearer #{token_for(@user)}" }

          let(:id) do
            u = User.create!(name: 'Raider', email: 'raider@skywalker.net', password: '1234567', password_confirmation: '1234567')
            u.id
          end
          let(:user) do
            { data: { type: 'user', attributes: { name: 'Twix', email: 'twix@skywalker.net' } } }
          end
          run_test!
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end
      end
      delete 'Deletes a users' do
        tags 'User'
        security [Bearer: {}]

        consumes 'application/json'
        produces 'application/json'
        parameter name: 'id', in: :path, type: :string

        response '204', 'user updated' do
          let(:Authorization) { "Bearer #{token_for(@user)}" }

          let(:id) do
            u = User.create!(name: 'Raider', email: 'raider@skywalker.net', password: '1234567', password_confirmation: '1234567')
            u.id
          end
          let(:user) do
            { user: { name: 'Twix', email: 'twix@skywalker.net' } }
          end
          run_test!
        end
      end
    end
  end
end
