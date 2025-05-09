class Api::V1::AttendancesController < ApplicationController
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

          render json: { attendances: result }

        else
          render json: { error: "Group not found" }, status: :not_found
        end
      else
        render json: { error: "Name and date must be provided" }, status: :bad_request
      end
    end

    def create
      attendance = Attendance.new(attendance_params)
      if attendance.save
        render json: { attendance: attendance.as_json(include: :user) }, status: :ok
      else
        render json: { error: attendance.errors.full_messages }, status: :bad_request
      end
    end

    def update
      attendance = Attendance.find(params[:id])
      if attendance.update(attendance_params)
        render json: { attendance: attendance.as_json(include: :user) }, status: :ok
      else
        render json: { error: attendance.errors.full_messages }, status: :bad_request
      end
    end

    def destroy
      attendance = Attendance.find(params[:id])
      attendance.destroy!
      render json: { message: "削除に成功しました" }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { message: "出席データが見つかりません" }, status: :not_found
    rescue ActiveRecord::RecordNotDestroyed
      render json: { message: "削除に失敗しました" }, status: :unprocessable_entity
    end

    private

    def attendance_params
      params.require(:attendance).permit(
        :date,
        :schedule,
        :attendances_status,
        :remarks,
        :user_id,
        :group_id
      )
    end
end
