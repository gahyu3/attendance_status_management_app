require 'rails_helper'

RSpec.describe "Api::V1::Groups", type: :request do
  describe "GET /api/v1/groups" do
    let(:user) { create(:user, password: "password123", password_confirmation: "password123") }
    let!(:groups) { create_list(:group, 3) }

    let(:auth_headers) do
      post "/api/v1/sign_in", params: {
        email: user.email,
        password: "password123"
      }

      # レスポンスヘッダーから認証情報を抽出
      response.headers.slice('client', 'access-token', 'uid')
    end

    describe "GET /api/v1/groups" do
      it "グループ一覧を取得" do
        get "/api/v1/groups", headers: auth_headers

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["groups"].length).to eq(3)
        expect(json["groups"].first).to include("id", "name")
      end
    end

    describe "POST /api/v1/groups" do
      context "処理が成功" do
        let(:params) do
          {
            group: {
              name: "テスト1"
            }
          }
        end
        it "グループを作成" do
          expect {
            post "/api/v1/groups", headers: auth_headers, params: params
          }.to change { Group.count }.by(1)

          expect(response).to have_http_status(:created)

          json = JSON.parse(response.body)
          expect(json["group"]).to include("name" => "テスト1")

        end
      end

      context "処理が失敗" do
        let(:valid_params) do
          {
            group: {
              name: ""
            }
          }
        end
        it "作成が失敗し、エラーステータスがかえる" do
          post "/api/v1/groups", headers: auth_headers, params: valid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PUT /api/v1/groups" do
      context "処理が成功" do
        it "変更後のレスポンスが変える" do
          group = create(:group, name: "テスト1")
          put "/api/v1/groups/#{group.id}", headers: auth_headers, params: { group: { name: "テスト2" }}
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json['group']['name']).to eq("テスト2")
        end
      end

      context "処理が失敗" do
        it "エラーレスポンスが返る" do
          group = create(:group, name: "テスト1")
          put "/api/v1/groups/#{group.id}", headers: auth_headers, params: { group: { name: "ああああああああああああああああああああ（10文字以上）" }}
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE /api/v1/groups" do
      context "処理が成功" do
        it "ステータスno_contentが返る" do
          group = create(:group, name: "テスト1")
          delete "/api/v1/groups/#{group.id}", headers: auth_headers
          expect(response).to have_http_status(:no_content)
        end
      end
    end

  end
end
