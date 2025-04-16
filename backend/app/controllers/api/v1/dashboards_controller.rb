class Api::V1::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:name].present? && params[:date].present?
      group = Group.find_by(name: params[:name])
      group_user_attendances = group.attendances.includes(:user).where(date: params[:date])

      if group
        render json: { group_user_attendances: group_user_attendances.as_json(include: :user)}
      else
        render json: { error: "Group not found" }, status: :not_found
      end
    else
      render json: { error: "Name and date must be provided" }, status: :bad_request
    end
  end

end
