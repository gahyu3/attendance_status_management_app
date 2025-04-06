class Api::V1::GroupsController < ApplicationController

  def index
    groups = Group.all
    render json: { groups: groups }
  end

end
