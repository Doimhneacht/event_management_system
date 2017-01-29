require 'rails_helper'

RSpec.describe "Attachments", type: :request do
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

      event = create(:event, owner: user.id, users: [user])
      @attachment = build(:attachment, user: User.find(event.owner), event: event)
    end

    subject { JSON.parse(response.body)['data'] }
    let(:event_id) { @attachment.event_id }

    it 'creates an attachment' do
      post "/api/events/#{event_id}/attachments",
           params: { filename: @attachment.filename,
                     content_type: @attachment.content_type,
                     file_contents: @attachment.file_contents }.to_json,
           headers: @req_headers

      expect(response).to have_http_status 201
      expect(subject['message']).to eq('File has been saved')
      saved_attachment = Attachment.find_by_id(subject['id'])
      expect(saved_attachment).to be_truthy
    end

    it 'deletes an attachment' do
      @attachment.save
      id = @attachment.id

      delete "/api/events/#{event_id}/attachments/#{id}", headers: @req_headers

      expect(response).to have_http_status 200
      expect(subject['message']).to eq('File has been deleted')
      expect(Attachment.find_by_id(id)).to be_falsey
    end
  end
end
