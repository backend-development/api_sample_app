# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticController, type: :controller do
  it('should get home') do
    get :home, params: {}, session: {}
    assert_response(:success)
  end
end
