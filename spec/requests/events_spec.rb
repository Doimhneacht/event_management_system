require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.describe 'Events', type: :request do

  context 'when request is correct' do
    before :each do
      user = create(:user, password: 'password')

      post '/oauth/token', params: {
                              grant_type: 'password',
                              email: user.email,
                              password: 'password'
      }

      @req_headers = {
          AUTHORIZATION: "Bearer #{JSON.parse(response.body)['access_token']}",
          CONTENT_TYPE: 'application/json'
      }

      @event = create(:event, users: [user], owner: user.id)
    end

    subject { JSON.parse(response.body)['data'] }
    let(:id) { @event.id }
    let(:owner_id) { @event.owner }
    let(:user) { User.find(@event.owner) }

    it 'shows closest events' do
      far_event = create(:event, time: @event.time + 50, users: [user], owner: owner_id)
      close_event = create(:event, time: @event.time + 5, users: [user], owner: owner_id)
      timestamp = (@event.time + 10).iso8601

      get "/api/events?due=#{timestamp}", params: { },
                                          headers: @req_headers

      expect(response).to have_http_status 200
      expect(subject[0]['id']).to eq(@event.id.to_s)
      expect(subject[1]['id']).to eq(close_event.id.to_s)
      expect(subject.length).to eq(2)
    end

    it 'shows an event' do
      get "/api/events/#{id}", params: { }, headers: @req_headers

      event_attributes = @event.as_json
      event_attributes.select! { |k,v| %w(time place purpose owner).include?(k) }
      event_attributes['time'] = event_attributes['time'].as_json

      expect(response).to have_http_status 200
      expect(subject['id']).to eq(id.to_s)
      expect(subject['type']).to eq('events')
      expect(subject['attributes']).to eq(event_attributes)
    end

    it 'updates an event' do
      req_params = {'place' => "Godric's Hollow" }

      expect(@event.place).not_to eq(req_params['place'])

      patch "/api/events/#{id}", params: req_params.to_json, headers: @req_headers

      expect(response).to have_http_status 200
      expect(@event.reload.place).to eq(req_params['place'])
    end

    it 'deletes an event' do
      delete "/api/events/#{id}", params: { }, headers: @req_headers

      expect(response).to have_http_status 200
      expect(Event.find_by_id(id)).to be_falsey
      expect(user.event_ids).not_to include id
    end

    it 'invites users to an event' do
      expect(@event.users).to eq [user]

      invited = create(:user)
      req_params = {users: {emails: [invited.email]}}.to_json

      post "/api/events/#{id}/invite", params: req_params, headers: @req_headers

      expect(response).to have_http_status 200
      expect(@event.reload.users).to include invited
    end

    it 'shows feed' do
      other_user = create(:user)
      first_change = create(:attachment, user: user, event: @event)
      second_change = create(:comment, text: 'second change', user: user, event: @event)
      third_change = create(:comment, text: 'third change', user: other_user, event: @event)

      get "/api/events/#{id}/feed", params: { }, headers: @req_headers

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
end
