# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  fixtures :users
  before { @user = users(:mando) }
  path '/users.json' do
    # get 'list all the users' do
    #   produces 'abpplication/json'

    #   response(200, 'successful') do
    #     schema type: :array,
    #            items: {
    #              type: :object,
    #              properties: {
    #                id: { type: :integer },
    #                name: { type: :string },
    #                email: { type: :string }
    #              },
    #              required: %w[id name email]
    #            }

    #     run_test!
    #   end
    # end

    post 'Register a new user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[name email password password_confirmation]
      }

      response(201, 'User created') do
        let(:user) do
          { user: {
            name: 'Leia',
            email: 'leia@organa.org',
            password: '12345678',
            password_confirmation: '12345678'
          } }
        end
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 email: { type: :string }
               }
        run_test!
      end
    end
  end

  # path '/users/new' do
  #   get('new user') do
  #     response(200, 'successful') do
  #       after do |example|
  #         # example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response&.body, symbolize_names: true) }
  #       end
  #       run_test!
  #     end
  #   end
  # end

  # path '/users/{id}/edit' do
  #   # You'll want to customize the parameter types...
  #   parameter name: 'id', in: :path, type: :string, description: 'id'

  #   get('edit user') do
  #     response(200, 'successful') do
  #       let(:id) { '123' }

  #       after do |example|
  #         # example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response&.body, symbolize_names: true) }
  #       end
  #       run_test!
  #     end
  #   end
  # end

  # path '/users/{id}.json' do
  #   get 'show user' do
  #     produces 'application/json'
  #     parameter name: 'id', in: :path, type: :string

  #     response 200, 'successful' do
  #       schema type: :object,
  #              properties: {
  #                id: { type: :integer },
  #                name: { type: :string },
  #                email: { type: :string }
  #              },
  #              required: %w[id name email]

  #       let(:id) do
  #         u = User.create!(name: 'Luke', email: 'luke@skywalker.net', password: '1234567', password_confirmation: '1234567')
  #         u.id
  #       end

  #       run_test!
  #     end
  #   end

  # patch('update user') do
  #   response(200, 'successful') do
  #     let(:id) { @user.id }

  #     after do |example|
  #       # example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response&.body, symbolize_names: true) }
  #     end
  #     run_test!
  #   end
  # end

  # put('update user') do
  #   parameter name: 'id', in: :path, type: :string, description: 'id', required: %w[id]
  #   parameter name: :users, in: :body, schema: {
  #     type: :object,
  #     properties: {
  #       name: { type: :string },
  #       email: { type: :string }
  #     }
  #   }
  #   response(200, 'successful') do
  #     let(:id) { @user.id }

  #     after do |example|
  #       # example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response&.body, symbolize_names: true) }
  #     end
  #     run_test!
  #   end
  # end

  # delete('delete user') do
  #   response(200, 'successful') do
  #     let(:id) { '123' }

  #     after do |example|
  #       # example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response&.body, symbolize_names: true) }
  #     end
  #     run_test!
  #   end
  # end
  # end
end
