class Api::V1::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:update, :destroy]

  def index
    groups = Group.all
    render json: { groups: groups }, status: :ok
  end

  def create
    group = Group.new(group_params)

    if group.save
      render json: { group: group }, status: :created
    else
      render json: { errors: group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @group.update(group_params)
      render json: { group: @group }, status: :ok
    else
      render json: { errors: @group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    head :no_content
  end

  private

  def set_group
    @group = Group.find_by(id: params[:id])
    return render json: { error: 'グループが見つかりません' }, status: :not_found unless @group
  end

  def group_params
    params.require(:group).permit(:name)
  end

end
