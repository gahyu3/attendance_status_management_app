class Api::V1::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:name].present? && params[:date].present?
      group = Group.find_by(name: params[:name])
      group_user_attendances = group.attendances.includes(:user).where(date: params[:date])

      if group
        result = group_user_attendances.map do |attendance|
          attendance.as_json(
            include: { user: { only: [:id, :user_name, :avatar_image] } },
            only: [:id, :date, :remarks, :user_id, :group_id]
          ).merge(
            schedule: attendance.schedule_i18n,
            attendances_status: attendance.attendances_status_i18n
          )
        end
        render json: { group_user_attendances: result }
      else
        render json: { error: "Group not found" }, status: :not_found
      end
    else
      render json: { error: "Name and date must be provided" }, status: :bad_request
    end
  end

end
