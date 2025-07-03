class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    render json: { user: @user }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
