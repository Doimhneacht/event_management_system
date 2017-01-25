class EventsController < ApplicationController
  before_action :set_event, except: :create

  # GET /api/events/:id
  def show
    return bad_request('The event does not exist') unless @event
    return forbidden unless user_can_read_event

    render json: @event.as_json(include: :users)
  end

  # POST /api/events
  def create
    full_params = event_params.merge(owner: current_resource_owner.id)
    @event = current_resource_owner.events.build(full_params)

    return bad_request('Time should be in the future') unless @event.valid? && @event.save

    render json: @event, status: :created
  end

  # PUT or PATCH /api/events/:id
  def update
    return forbidden unless user_can_modify_event
    return bad_request unless @event.update_attributes(event_params)

    render json: @event, include: :attachments, serializer: :event, status: :ok
  end

  # DELETE /api/events/:id
  def destroy
    return bad_request('The event does not exist') unless @event
    return forbidden unless user_can_modify_event

    @event.comments.destroy(@event.comments)
    @event.attachments.destroy(@event.attachments)
    @event.destroy

    render json: {message: 'The event has been deleted'}, status: :ok
  end

  # POST /api/events/:id/invite
  def invite
    return forbidden unless user_can_modify_event

    bad_emails = []
    users = []

    invited_users_params[:emails].each do |email|
      user = User.find_by_email(email)
      if user
        users << user
      else
        bad_emails << email
      end
    end

    unless bad_emails.empty?
      bad_emails.map! {|email| "#{email} is not among registered users"}
      return bad_request(bad_emails)
    end

    users.each {|user| @event.users << user}

    render json: {message: 'Users have been successfully invited'}, status: :ok
  end

  # GET events/:id/feed
  def feed
  end

  private

  def set_event
    @event = Event.find_by_id(params[:id])
  end

  def event_params
    params.require(:event).permit(:time, :place, :purpose)
  end

  def invited_users_params
    params.require(:users).permit(emails: [])
  end

  def user_can_read_event
    @event.user_ids.include?(doorkeeper_token.resource_owner_id)
  end

  def user_can_modify_event
    @event.owner == doorkeeper_token.resource_owner_id
  end
end
