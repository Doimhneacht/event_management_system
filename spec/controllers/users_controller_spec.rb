require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'Register a User' do

    it 'registers a valid user' do
      req_body = { user:
                       { email: 'testing_purpose@email.com',
                         password: 'password',
                         password_confirmation: 'password' } }

      post :create, params: req_body

      user = User.find_by_email('testing_purpose@email.com')
      expected_res_body = {data:
                               {id: user.id.to_s,
                                type: 'users',
                                attributes:
                                    {email: user.email}}}

      expect(user).to be_truthy
      expect(response).to have_http_status :created
      expect(response.body).to eq expected_res_body.to_json
    end

    it 'refuses to register invalid user' do
      req_body = { user:
                       { email: 'wrong_email.com',
                         password: '' } }

      post :create, params: req_body

      user = User.find_by_email('wrong_email.com')

      expect(user).to be_falsey
      expect(response).to have_http_status :bad_request
      expect(response.body).to include('Email is invalid', "Password can't be blank")
    end
  end

end
