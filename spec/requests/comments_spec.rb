require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  context 'with correct request' do

    before :each do
      user = create(:user, password: 'wibbly_wobbly')

      post '/oauth/token', params: {
                              grant_type: 'password',
                              email: user.email,
                              password: 'wibbly_wobbly'
                           }

      @req_headers = {
          AUTHORIZATION: "Bearer #{JSON.parse(response.body)['access_token']}",
          CONTENT_TYPE: 'application/json'
      }

      @comment = create(:comment, user_id: user.id)
      event = Event.find(@comment.event_id)
      event.users << [user, User.find(event.owner)]
    end

    subject { JSON.parse(response.body)['data'] }
    let(:event_id) { Event.find(@comment.event_id).id }
    let(:id) { @comment.id }

    it 'shows all comments' do
      get "/api/events/#{event_id}/comments", headers: @req_headers

      # byebug
      expect(response).to have_http_status 200
      expect(subject[0]['id']).to eq(@comment.id.to_s)
      expect(subject[0]['type']).to eq('comments')
    end

    it 'creates a comment' do
      text = 'Agus is maith liomsa sú!'

      post "/api/events/#{event_id}/comments",
           params: { text: text }.to_json,
           headers: @req_headers

      expect(response).to have_http_status 201
      expect(subject['type']).to eq('comments')
      expect(subject['attributes']['text']).to eq(text)
      comment = Comment.find(subject['id'])
      expect(comment.text).to eq(text)
    end

    it 'updates a comment' do
      new_text = 'Agus is maith liomsa sú talún!'
      expect(@comment.text).not_to eq(new_text)

      patch "/api/events/#{event_id}/comments/#{id}",
            params: { text: new_text }.to_json,
            headers: @req_headers

      expect(response).to have_http_status 200
      expect(subject['message']).to eq('The comment has been updated')
      expect(@comment.reload.text).to eq(new_text)
    end

    it 'deletes a comment' do
      delete "/api/events/#{event_id}/comments/#{id}", headers: @req_headers

      expect(response).to have_http_status 200
      expect(subject['message']).to eq('The comment has been deleted')
      expect(Comment.find_by_id(id)).to be_falsey
    end
  end
end
