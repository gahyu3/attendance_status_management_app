require 'rails_helper'

RSpec.describe "Api::V1::Profiles", type: :request do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  let(:auth_headers) do
    post "/api/v1/sign_in", params: {
      email: user.email,
      password: "password123"
    }

    response.headers.slice('client', 'access-token', 'uid')
  end

  describe "GET api/v1/profile" do
    context "処理が成功" do
      it "ログインユーザーの情報を取得" do
        get "/api/v1/profile", headers: auth_headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["user_name"]).to eq("#{user.user_name}")
      end
    end
  end

  describe "PUT /api/v1/profile" do
    context "処理が成功" do
      it "ログインユーザーの情報を更新" do
        put "/api/v1/profile", headers: auth_headers, params: {
          user: {user_name: "山田太郎"}
        }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["user_name"]).to eq("山田太郎")
      end
    end

    context "処理が失敗" do
      it "エラーメッセージが変える" do
        put "/api/v1/profile", headers: auth_headers, params: {
          user: {user_name: "あああああああああああああああああああああああああああああああああああ（30文字以上）"}
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
