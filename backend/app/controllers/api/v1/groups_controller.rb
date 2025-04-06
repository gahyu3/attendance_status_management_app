class Api::V1::GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    groups = Group.all
    render json: { groups: groups }
  end

end
