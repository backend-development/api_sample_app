# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  fixtures :users
  let(:valid_session) do
    {}
  end
  let(:valid_attributes) do
    { password: '12349808134' }
  end
  before { @user = users(:mando) }
  it('should get index') do
    get(:index, params: {}, session: valid_session)
    assert_response(:success)
  end
  it('should get new') do
    get(:new, params: {}, session: valid_session)
    assert_response(:success)
  end
  it('should not create user with same name') do
    expect do
      post(:create, params: { user: { name: @user.name, email: ('new' + @user.email), password: valid_attributes[:password], password_confirmation: valid_attributes[:password] } }, session: valid_session)
    end.to(change { User.count }.by(0))
  end
  it('should not create user with same email') do
    expect do
      post(:create, params: { user: { name: ('new' + @user.name), email: @user.email, password: valid_attributes[:password], password_confirmation: valid_attributes[:password] } }, session: valid_session)
    end.to(change { User.count }.by(0))
  end
  it('should create user with new name, new email and long password') do
    expect do
      post(:create, params: { id: @user.id, user: { name: ('new' + @user.name), email: ('new.' + @user.email), password: valid_attributes[:password], password_confirmation: valid_attributes[:password] } }, session: valid_session)
    end.to(change { User.count })
    assert_redirected_to(user_url(User.last))
  end
  it('should show user') do
    get(:show, params: { id: @user.id }, session: valid_session)
    assert_response(:success)
  end
  it('should get edit') do
    get(:edit, params: { id: @user.id }, session: valid_session)
    assert_response(:success)
  end
  it('should update user') do
    patch(:update, params: { id: @user.id, user: { email: ('other' + @user.email) } }, session: valid_session)
    assert_redirected_to(users_url)
  end
  it('should not destroy user who has debts') do
    expect do
      delete(:destroy, params: { id: @user.id }, session: valid_session)
    end.to(change { User.count }.by(0))
    assert_redirected_to(users_url)
  end
  it('should destroy user without debts') do
    MoneyTransaction.delete_all
    expect do
      delete(:destroy, params: { id: @user.id }, session: valid_session)
    end.to(change { User.count }.by(-1))
    assert_redirected_to(users_url)
  end
end
