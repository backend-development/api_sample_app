# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  fixtures :users
  before { @user = users(:mando) }
  path '/users.json' do
    get 'list all the users' do
      produces 'abpplication/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   email: { type: :string }
                 },
                 required: %w[id name email]
               }

        run_test!
      end
    end
  end

  path '/users/{id}.json' do
    get 'show user' do
      produces 'application/json'
      parameter name: 'id', in: :path, type: :string

      response 200, 'successful' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 email: { type: :string }
               },
               required: %w[id name email]

        let(:id) do
          u = User.create!(name: 'Luke', email: 'luke@skywalker.net', password: '1234567', password_confirmation: '1234567')
          u.id
        end

        run_test!
      end
    end
  end
end
