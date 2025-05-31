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

    it "グループ一覧を取得" do
      get "/api/v1/groups", headers: auth_headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["groups"].length).to eq(3)
      expect(json["groups"].first).to include("id", "name")
    end
  end
end
