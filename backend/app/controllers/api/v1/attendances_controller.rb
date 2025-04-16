class Api::V1::AttendancesController < ApplicationController
    before_action :authenticate_user!

    def create
      attendance = Attendances.new(attendance_params)
      if attendance.save
        render json: { attendances: attendances }, status: :ok
      else
        render json: { error: "失敗" }
      end
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
