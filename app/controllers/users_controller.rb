class UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      bad_request(@user.errors.full_messages)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
