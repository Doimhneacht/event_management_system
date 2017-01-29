require 'rails_helper'

RSpec.describe 'Events', type: :request do

  context 'when request is correct' do
    before(:all) do
      create_sample_user
      get_access_token
      create_sample_event
    end

    it 'shows closest events' do
      far_event = Event.create(time: @event.time + 50, owner: @user.id)
      close_event = Event.create(time: @event.time + 5, owner: @user.id)
      timestamp = (@event.time + 10).iso8601
      @user.events << far_event
      @user.events << close_event

      get "/api/events?due=#{timestamp}", params: { },
                                          headers: @req_headers

      expect(response).to have_http_status 200

      event_json = "\"id\":\"#{@event.id}\",\"type\":\"events\""
      close_event_json = "\"id\":\"#{close_event.id}\",\"type\":\"events\""
      far_event_json = "\"id\":\"#{far_event.id}\",\"type\":\"events\""

      expect(response.body).to include(event_json, close_event_json)
      expect(response.body).not_to include(far_event_json)
    end

    it 'shows an event' do
      get "/api/events/#{@event_data['id']}", params: { },
                                              headers: @req_headers

      event_attributes = Event.find(@event_data['id']).as_json
      event_attributes.select! { |k,v| %w(time place purpose owner).include?(k) }
      res_body = { id: @event_data['id'],
                   type: 'events',
                   attributes: event_attributes }.to_json

      expect(response).to have_http_status 200
      expect(response.body).to include(res_body)
    end

    it 'updates an event' do
      req_params = {'place' => "Godric's Hollow" }
      db_event = Event.find_by_id(@event_data['id'])

      expect(db_event.place).not_to eq(req_params['place'])

      patch "/api/events/#{@event_data['id']}", params: req_params.to_json,
                                                headers: @req_headers

      expect(response).to have_http_status 200

      expect(db_event.reload.place).to eq(req_params['place'])
    end

    it 'deletes an event' do
      delete "/api/events/#{@event_data['id']}", params: { },
                                                 headers: @req_headers

      expect(response).to have_http_status 200
      expect(Event.find_by_id(@event_data['id'])).to be_falsey
      expect(@user.event_ids).not_to include @event_data['id']
    end

    it 'invites users to an event' do
      expect(@event.users).to eq [@user]

      invited = User.create(email: 'invited@mail.com', password: 'password')
      req_params = {users: {emails: [invited.email]}}.to_json

      post "/api/events/#{@event_data['id']}/invite", params: req_params,
                                                      headers: @req_headers

      expect(response).to have_http_status 200
      expect(@event.reload.users).to include invited
    end

    it 'shows feed' do
      other_user = User.create(email: 'other@user.com', password: 'password')
      first_change = Attachment.create(filename: 'bubble',
                                       content_type: 'bla',
                                       file_contents: 'bla',
                                       user_id: @user.id,
                                       event_id: @event.id)
      second_change = Comment.create(text: 'second change',
                                     user_id: @user.id,
                                     event_id: @event.id)
      third_change = Comment.create(text: 'third change',
                                    user_id: other_user.id,
                                    event_id: @event.id)

      get "/api/events/#{@event_data['id']}/feed", params: { },
                                                   headers: @req_headers

      res_events = JSON.parse(response.body)
      get_events_order = ->(res_events) {
        order = []
        res_events.each do |event_data|
          if event_data['type'] == 'comments'
            change = Comment.find(event_data['id'])
          elsif event_data['type'] == 'attachments'
            change = Attachment.find(event_data['id'])
          end
          order << change
        end
        order
      }
      res_events_order = get_events_order.(res_events)

      expect(response).to have_http_status 200
      expect(res_events_order).to eq [third_change, second_change, first_change]
    end
  end

  private

  def create_sample_user
    @user = User.create(email: 'email@email.com', password: 'password')
  end

  def get_access_token
    req_body = {
        "grant_type": "password",
        "email": @user.email,
        "password": "password"
    }

    post '/oauth/token', params: req_body

    token = JSON.parse(response.body)['access_token']

    @req_headers = {
        "AUTHORIZATION" => "Bearer #{token}",
        "CONTENT_TYPE" => "application/json"
    }
  end

  def create_sample_event
    req_body = {
        "event" => {
            "time" => DateTime.tomorrow,
            "place" => "test database",
            "purpose" => "testing"
        }
    }.to_json

    post '/api/events', params: req_body, headers: @req_headers

    @event_data = JSON.parse(response.body)['data']
    @event = Event.find(@event_data['id'])
  end
end
