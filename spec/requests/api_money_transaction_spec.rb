# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Stand Alone API', type: :request do
  describe 'MoneyTransaction' do
    fixtures :users
    fixtures :money_transactions
    before { @user = users(:mando) }
    path '/api/v0/money_transactions' do
      get 'list all the MoneyTransaction' do
        tags 'MoneyTransaction'
        produces 'application/json'
        security [Bearer: {}]
        response(200, 'successful') do
          let(:Authorization) { "Bearer #{token_for(@user)}" }
          schema type: :array,
                items: {
                      type: :object,
                      properties: {
                        amount: { type: :string },
                        paid_at: { type: :string, nullable: true }
                      },
                      required: %w[amount]
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
    end

    path '/api/v0/money_transactions/{id}' do
      get 'show user' do
        tags 'MoneyTransaction'
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
                       type: { type: :string, enum: ['money_transaction'] },
                       attributes: {
                         type: :object,
                         properties: {
                           amount: { type: :string },
                           paid_at: {  type: :string, format: :date }
                         },
                         required: %w[amount]
                       },
                       relationships: {
                         type: :object,
                         properties: {
                           creditor: { type: :object },
                           debitor: { type: :object }
                         },
                         required: %w[creditor debitor]
                       }
                     },
                     required: %w[id type attributes relationships]
                   }
                 }
          let(:id) do
            m = money_transactions(:one)
            m.id
          end

          run_test!
        end
      end
    end
  end
end
