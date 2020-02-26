# frozen_string_literal: true

require 'swagger_helper'

describe 'Users API' do
  path '/users' do
    post 'Registers a new User' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :users, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[name email password password_confirmation]
      }

      response '201', 'user created' do
        let(:user) { { name: 'Ray', email: 'ray@skywaler.org' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: '' } }
        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'Retrieves a User' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 email: { type: :string }
               },
               required: %w[id name email]

        let(:id) { User.create(name: 'Rao', email: 'ray@skywalker.org').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:Accept) { 'application/foo' }
        run_test!
      end
    end
  end
end
