class Api::V1::AttendancesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_attendance, only: [:update, :destroy]

    def index
      unless params[:group_id].present? && params[:date].present?
        return render json: { error: "group_idまたはdateのパラメータがありません" }, status: :bad_request
      end

      group = Group.find_by(id: params[:group_id])
      unless group
        return render json: { error: "グループが見つかりません" }, status: :not_found
      end

      attendances = group.attendances.includes(:user).where(date: params[:date])
      render json: { attendances: attendances }, status: :ok
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
      if attendance.update(attendance_params)
        render json: { attendance: attendance.as_json(include: :user) }, status: :ok
      else
        render json: { error: attendance.errors.full_messages }, status: :bad_request
      end
    end

    def destroy
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

    def set_attendance
      attendance = Attendance.find(params[:id])
    end
end
