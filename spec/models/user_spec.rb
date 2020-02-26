# frozen_string_literal: true

RSpec.describe(User, type: :model) do
  fixtures :users
  let(:valid_attributes) do
    { password: '12349808134' }
  end
  before { @user = users(:mando) }
  it('no new user without name') do
    u = User.create(email: ('new' + @user.email), password: valid_attributes[:password], password_confirmation: valid_attributes[:password])
    expect(u).to be_invalid
  end
  it('no new user with existing name') do
    u = User.create(name: @user.name, email: ('new' + @user.email), password: valid_attributes[:password], password_confirmation: valid_attributes[:password])
    expect(u).to be_invalid
  end
  it('no new user without password') do
    u = User.create(name: ('new' + @user.name), email: ('new' + @user.email))
    expect(u).to be_invalid
  end
  it('no new user without  e-mail') do
    u = User.create(name: ('new' + @user.name), password: valid_attributes[:password], password_confirmation: valid_attributes[:password])
    expect(u).to be_invalid
  end
  it('no new user with existing e-mail') do
    u = User.create(name: ('new' + @user.name), email: @user.email, password: valid_attributes[:password], password_confirmation: valid_attributes[:password])
    expect(u).to be_invalid
  end
  it('new user with new name, e-mail and valid password can be created') do
    u = User.create(name: ('new' + @user.name), email: ('new' + @user.email), password: valid_attributes[:password], password_confirmation: valid_attributes[:password])
    expect(u).to be_valid
  end
end
