class Api::V1::AttendancesController < ApplicationController
    before_action :authenticate_user!

    def create
      attendance = Attendance.new(attendance_params)
      if attendance.save
        render json: { attendance: attendance }, status: :ok
      else
        render json: { error: attendance.errors.full_messages }, status: :bad_request
      end
    end

    def update
      attendance = Attendance.find(params[:id])
      if attendance.update(attendance_params)
        render json: { attendance: attendance }, status: :ok
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
