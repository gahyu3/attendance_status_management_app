class Api::V1::AuthController < ApplicationController
  require 'googleauth/id_tokens'

  # SECURE_EMAIL = ENV['SECURE_EMAIL']

  def login
    id_token = params[:id_token]

    payload = Google::Auth::IDTokens.verify_oidc(id_token, aud: ENV['GOOGLE_CLIENT_ID'])

    # emailが許可たされたものか検証
    # unless payload['email'] == SECURE_EMAIL
    #   render json: { message: "無効なメールアドレスです" }, status: :unauthorized
    # end

    # emailが作成or検索
    user = User.find_or_create_by(email: payload['email']) do |u|
      u.user_name = payload['name']
    end

    token_struct = user.create_token
    user.save!
    response.headers.merge!(user.build_auth_headers(token_struct.token, token_struct.client))

    render json: { data: user }, status: :ok

    rescue Google::Auth::IDTokens::SignatureError
      render json: { error: '無効なtokenです' }, status: :unauthorized
    end
end
