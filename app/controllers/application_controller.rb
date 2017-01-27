class ApplicationController < ActionController::API
  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers
  before_action :doorkeeper_authorize!

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render text: '', content_type: 'text/plain'
    end
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  ############################################
  ## Json responses with different statuses ##
  ############################################
  def not_found(resource)
    render json: {errors: "#{resource.capitalize} doesn't exist"}, status: :not_found
  end

  def bad_request(*message)
    if message.empty?
      render :json, status: :bad_request
    else
      render json: {errors: message[0]}, status: :bad_request
    end
  end

  def forbidden
    render json: {errors: 'User cannot modify this resource'}, status: :forbidden
  end
end
