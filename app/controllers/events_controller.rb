class EventsController < ApplicationController
  before_action :set_event, except: [:create, :index]
  before_action :check_if_event_exists, except: [:create, :index]

  # GET /api/events/:id
  def show
    return forbidden unless user_can_read_event

    render json: @event, status: :ok
  end

  # GET /api/events?due={timestamp}
  def index
    return bad_request('No time interval provided') unless params[:due]

    begin
      timestamp = DateTime.iso8601(params[:due])
      due_events = current_resource_owner.events
                       .where('time between (?) and (?)', Time.now, timestamp)

      render json: due_events, status: :ok
    rescue ArgumentError => e
      bad_request('Time interval should be in ISO8601 format')
    end
  end

  # POST /api/events
  def create
    @event = Event.new(event_params)
    @event.owner = current_resource_owner.id
    @event.user_ids = [current_resource_owner.id]

    return bad_request('Time should be in the future') unless @event.valid? && @event.save

    render json: @event, status: :created
  end

  # PUT or PATCH /api/events/:id
  def update
    return forbidden unless user_is_owner
    return bad_request unless @event.update_attributes(event_params)

    render json: @event, status: :ok
  end

  # DELETE /api/events/:id
  def destroy
    return bad_request('The event does not exist') unless @event
    return forbidden unless user_is_owner

    @event.comments.destroy(@event.comments)
    @event.attachments.destroy(@event.attachments)
    @event.destroy

    render json: {message: 'The event has been deleted'}, status: :ok
  end

  # POST /api/events/:id/invite
  def invite
    return forbidden unless user_is_owner

    invite_service = InviteService.new(invited_users_params[:emails], @event)
    invite_service.return_possible_errors
    invite_service.invite_users

    render json: {message: 'Users have been successfully invited'}, status: :ok
  end

  # GET events/:id/feed
  def feed
    return forbidden unless user_is_owner

    feed = FeedService.new(@event).generate_feed_json

    render json: feed, status: :ok
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

  def user_is_owner
    @event.owner == doorkeeper_token.resource_owner_id
  end

  def check_if_event_exists
    not_found(@event) unless @event
  end
end
