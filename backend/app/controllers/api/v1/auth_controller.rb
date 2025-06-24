class Api::V1::AuthController < ApplicationController
  require 'googleauth/id_tokens'
  require 'net/http'
  require 'uri'
  require 'json'

  GOOGLE_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token'

  # SECURE_EMAIL = ENV['SECURE_EMAIL']

  def login
    authorization_code = params[:code]
    tokens = exchange_code_for_tokens(authorization_code)
    payload = Google::Auth::IDTokens.verify_oidc(tokens["id_token"], aud: ENV['GOOGLE_CLIENT_ID'])

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

private

  def exchange_code_for_tokens(code)
    uri = URI(GOOGLE_TOKEN_ENDPOINT)
    response = Net::HTTP.post_form(uri, {
      code: code,
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      redirect_uri: ENV['GOOGLE_REDIRECT_URI'],
      grant_type: 'authorization_code'
    })

    json = JSON.parse(response.body)
    raise "Google token error: #{json}" if json['error']

    json
  end
end
