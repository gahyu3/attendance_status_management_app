class Api::V1::DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:name].present?
      group = Group.includes(attendants: :user).find_by(name: params[:name])

      if group
        render json: { group: group, group_attendants: group.attendants.as_json(include: :user) }
      else
        render json: { error: "Group not found" }, status: :not_found
      end
    end
      groups = Group.all
      render json: { groups: groups }
  end

end
