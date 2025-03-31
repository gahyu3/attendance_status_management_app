class Api::V1::DashboardsController < ApplicationController

  def index
    @group = Group.all
    render json: { group: @group }
  end

end
