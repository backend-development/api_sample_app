# frozen_string_literal: true

# file /spec/requests/api_spec.rb

require 'swagger_helper'

RSpec.describe 'Stand Alone API', type: :request do
  describe 'MoneyTransaction' do
    fixtures :users
    fixtures :money_transactions
    before { @user = users(:mando) }
    path '/api/v1/money_transactions' do
      get 'list all the MoneyTransaction' do
        tags 'MoneyTransaction'
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
                         type: { type: :string, enum: ['money_transaction'] },
                         attributes: {
                           type: :object,
                           properties: {
                             amount: { type: :string },
                             paid_at: { type: :string }
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

      post 'Creates a MoneyTransaction' do
        tags 'MoneyTransaction'
        security [Bearer: {}]
        consumes 'application/json'
        produces 'application/json'
        parameter name: :money_transaction,
                  in: :body,
                  schema: {
                    type: :object,
                    properties: {
                      data: {
                        type: :object,
                        properties: {
                          type: { type: :string, enum: ['money_transaction'] },
                          attributes: {
                            type: :object,
                            properties: {
                              amount: { type: :number },
                              paid_at: { type: :date },
                              creditor_id: { type: :string },
                              debitor_id: { type: :string }
                            },
                            required: %w[amount creditor debitor]
                          }
                        }
                      }
                    }
                  }

        response '201', 'money_transaction created' do
          let(:Authorization) { "Bearer #{token_for(@user)}" }
          let(:money_transaction) do
            u1 = User.first
            u2 = User.second
            return {
              data: {
                type: 'money_transaction',
                attributes: {
                  amount: 10.50,
                  creditor_id: u1.id,
                  debitor_id: u2.id
                }
              }
            }
          end
          run_test!
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end

        response '422', "amount can't be blank" do
          let(:Authorization) { "Bearer #{token_for(@user)}" }
          let(:money_transaction) do
            u1 = User.first
            u2 = User.second
            return {
              data: {
                type: 'money_transaction',
                attributes: {
                  creditor_id: u1.id,
                  debitor_id: u2.id
                }
              }
            }
          end
          run_test!
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end
      end
    end

    path '/api/v1/money_transactions/{id}' do
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
      patch 'Updates a MoneyTransactions data' do
        tags 'MoneyTransaction'
        security [Bearer: {}]

        consumes 'application/json'
        produces 'application/json'
        parameter name: 'id', in: :path, type: :string
        parameter name: :money_transaction,
                  in: :body,
                  schema: {
                    type: :object,
                    properties: {
                      data: {
                        type: :object,
                        properties: {
                          type: { type: :string, enum: ['money_transaction'] },
                          id: { type: :string },
                          attributes: {
                            type: :object,
                            properties: {
                              amount: { type: :string },
                              paid_at: { type: :string, format: :date },
                              creditor_id: { type: :string },
                              debitor_id: { type: :string }
                            },
                            required: %w[]
                          }
                        }
                      }
                    }
                  }

        response '200', 'moneytransaction updated: bezahlt' do
          let(:Authorization) { "Bearer #{token_for(@user)}" }
          let(:id) do
            u1 = User.first
            u2 = User.second
            m = MoneyTransaction.create(creditor_id: u1.id, debitor_id: u2.id, amount: '22.90')
            m.id
          end
          let(:money_transaction) do
            { data: { type: 'money_transaction', attributes: { paid_at: '2020-04-01' } } }
          end
          run_test!
          after do |example|
            example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
          end
        end
      end
      delete 'Deletes a moneytransaction' do
        tags 'MoneyTransaction'
        security [Bearer: {}]

        consumes 'application/json'
        produces 'application/json'
        parameter name: 'id', in: :path, type: :string

        response '204', 'moneytransaction deleted' do
          let(:Authorization) { "Bearer #{token_for(@user)}" }
          let(:id) do
            u1 = User.first
            u2 = User.second
            m = MoneyTransaction.create(creditor_id: u1.id, debitor_id: u2.id, amount: '22.90')
            m.id
          end
          run_test!
        end
      end
    end
  end
end
