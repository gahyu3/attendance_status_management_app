class Api::V1::ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user, status: :ok
  end

  def update
    if current_user.update(profile_params)
      render json: current_user, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:user_name, :avatar_image)
  end

end
