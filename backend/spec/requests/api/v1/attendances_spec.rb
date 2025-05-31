require 'rails_helper'

RSpec.describe "Api::V1::Attendances", type: :request do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }
  let!(:group) { create(:group, name: "グループ1") }
  let!(:group) { create(:group, name: "グループ2") }
  let!(:attendance) do
    create(:attendance,
      date: Date.current,
      schedule: 0,
      attendances_status: 0,
      remarks: "特記事項なし",
      user: user,
      group: group
    )
  end

  let(:auth_headers) do
    post "/api/v1/sign_in", params: {
      email: user.email,
      password: "password123"
    }

    # レスポンスヘッダーから認証情報を抽出
    response.headers.slice('client', 'access-token', 'uid')
  end

  describe "GET /api/v1/attendances" do

    context "処理が成功" do
      it "出席状況を一覧を獲得" do
        get "/api/v1/attendances", headers: auth_headers, params: {
          group_id: group.id,
          date: attendance.date
        }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["attendances"].first).to include("id",
                                                      "date",
                                                      "schedule",
                                                      "attendances_status",
                                                      "remarks",
                                                      "user_id",
                                                      "group_id",
                                                      "user")
      end
    end

    context "処理が失敗" do
      it "dataパラメータ不足" do
        get "/api/v1/attendances", headers: auth_headers, params: {
          date: attendance.date
        }

        expect(response).to have_http_status(:bad_request)
      end

      it "group_idパラメータ不足" do
        get "/api/v1/attendances", headers: auth_headers, params: {
          group_id: group.id
        }

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:bad_request)
        expect(json["error"]).to eq("group_idまたはdateのパラメータがありません")
      end

      it "存在しないグループ" do
        get "/api/v1/attendances", headers: auth_headers, params: {
          group_id: 100,
          date: attendance.date
        }

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json["error"]).to eq("グループが見つかりません")
      end
    end
  end

  describe "POST /api/v1/attendances" do
    context "処理が成功" do
      let(:valid_params) do
        {
          attendance: {
            user_id: user.id,
            group_id: group.id,
            date: Date.yesterday,
            schedule: "full_day_attendance",
            attendances_status: "present",
            remarks: "テスト作成"
          }
        }
      end
      it "出席状況を作成" do

        expect {
          post "/api/v1/attendances", params: valid_params, headers: auth_headers
        }.to change { Attendance.count }.by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["attendance"]).to include(
          "user_id" => user.id,
          "group_id" => group.id,
          "remarks" => "テスト作成",
        )

      end
    end

    context "処理が失敗" do
      let(:valid_params) do
        {
          attendance: {
            user_id: nil,
            group_id: nil,
            date: Date.yesterday,
            schedule: "full_day_attendance",
            attendances_status: "present",
            remarks: "テスト作成"
          }
        }
      end

      it "エラーレスポンスが返る" do

        post "/api/v1/attendances", headers: auth_headers, params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/attendances" do

    context "処理が成功" do
      it "変更後のレスポンスが変える" do
        attendance = create(:attendance,
                      date: Date.yesterday,
                      schedule: 0,
                      attendances_status: 0,
                      remarks: "特記事項なし",
                      user: user,
                      group: group
                    )
        put "/api/v1/attendances/#{attendance.id}", headers: auth_headers, params: { attendance: {attendances_status: "away"} }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['attendance']['attendances_status']).to eq('away')
      end
    end

    context "処理が失敗" do
      it "エラーレスポンスが返る" do
        attendance = create(:attendance,
              date: Date.yesterday,
              schedule: 0,
              attendances_status: 0,
              remarks: "特記事項なし",
              user: user,
              group: group
            )
        put "/api/v1/attendances/#{attendance.id}", headers: auth_headers, params: { attendance: {remarks: "ああああああああああああああああああああ（20文字以上）"} }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "500エラーが返る" do
        attendance = create(:attendance,
          date: Date.yesterday,
          schedule: 0,
          attendances_status: 0,
          remarks: "特記事項なし",
          user: user,
          group: group
        )
        put "/api/v1/attendances/#{attendance.id}", headers: auth_headers, params: { attendance: { attendances_status: 999 }}
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "DELETE /api/v1/attendances" do
    context "処理が成功" do
      it "削除メッセージが届くこと" do
        attendance = create(:attendance,
                              date: Date.yesterday,
                              schedule: 0,
                              attendances_status: 0,
                              remarks: "特記事項なし",
                              user: user,
                              group: group
                            )
        delete "/api/v1/attendances/#{attendance.id}", headers: auth_headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('削除に成功しました')
      end
    end

    context "処理が失敗" do
      it "失敗のメッセージが届く" do
        attendance = create(:attendance,
                      date: Date.yesterday,
                      schedule: 0,
                      attendances_status: 0,
                      remarks: "特記事項なし",
                      user: user,
                      group: group
                    )
        delete "/api/v1/attendances/123456", headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
