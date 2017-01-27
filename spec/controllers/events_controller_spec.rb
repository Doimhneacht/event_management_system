require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  context 'Correct request' do
    before(:all) do
      user = User.create(email: 'email@email.com', password: 'password')
      post Doorkeeper::TokensController.create
    end

    describe 'Show closest events' do

    end

    describe 'Show an event' do

    end

    describe 'Update an event' do

    end

    describe 'Delete an event' do

    end

    describe 'Invite users to an event' do

    end
  end

  context 'Incorrect request' do

    describe 'Show closest events' do

    end

    describe 'Show an event' do

    end

    describe 'Update an event' do

    end

    describe 'Delete an event' do

    end

    describe 'Invite users to an event' do

    end
  end

end
