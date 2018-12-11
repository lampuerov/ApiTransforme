
class Api::ApiController < ActionController::API

  def token
    url = "https://auth.brightidea.com/_oauth2/token"
    info_auth  = HTTParty.post(url,
                              {
                                  :headers =>
                                      {"Content-Type" => "application/json"},
                                  :body =>
                                      {
                                      :grant_type => "password",
                                      :client_id => "f061d4b1e62811e8aa5a0a720a822d3c",
                                      :client_secret => "619ebf2a27b180b6f7488235eaf4fc83",
                                      :username => "laampuero@uc.cl",
                                      :password => "ilovetransforme"
                                    }.to_json
                              })
    a_token = info_auth.parsed_response["access_token"]
    render json: {"XD": "Formato Incorrecto _id"}, status: 200
  end

  
end