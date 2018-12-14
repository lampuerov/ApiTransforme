require 'json'


class Api::ApiController < ActionController::API

  $empresas = {"transforme":{"empresa": "transforme", "client_id": "f061d4b1e62811e8aa5a0a720a822d3c", "client_secret": "619ebf2a27b180b6f7488235eaf4fc83"},
                 "entel":{"empresa": "entel", "client_id": "eb12cbf3ff4d11e8aa5a0a720a822d3c", "client_secret": "f1ffa5f27551f82037541b4d7c5162d4"},
                "cencosud":{"empresa": "cencosud", "client_id": "f32f0e32ff0611e8aa5a0a720a822d3c", "client_secret": "5ad4428cce479688ba14a9a87867f81e"},
                 "abastible":{"empresa": "abastible", "client_id": "ef9b119cff4f11e8aa5a0a720a822d3c", "client_secret": "b48c053021dede66d929da223c1fca40"},
                 "bdp":{"empresa": "bdp", "client_id": "160ec5b7ff5011e8aa5a0a720a822d3c", "client_secret": "4c5a4dbea9dfb15a16a38d5d6a95b11d"},
                 "bicevida":{"empresa": "bicevida", "client_id": "4d546d90ff5011e8aa5a0a720a822d3c", "client_secret": "6389ba5615a9da24c3f675aac58f3396"},
                 "coordinador":{"empresa": "coordinador", "client_id": "060ae9cdff5011e8aa5a0a720a822d3c", "client_secret": "f0b582375fbe380ffdcc94ba26619bca"},
                 "esb":{"empresa": "esb", "client_id": "195ac73bff4f11e8aa5a0a720a822d3c", "client_secret": "a41b534253ae68d3b4f46502fdc7a2c9"}
               }

  def token
    $empresa = params["empresa"]
    url = "https://auth.brightidea.com/_oauth2/token"
    info_auth  = HTTParty.post(url,
                              {
                                  :headers =>
                                      {"Content-Type" => "application/json"},
                                  :body =>
                                      {
                                      :grant_type => "password",
                                      :client_id => $empresas[$empresa.to_sym][:client_id],
                                      :client_secret => $empresas[$empresa.to_sym][:client_secret],
                                      :username => "gjara@transforme.cl",
                                      :password => "Workhard2017"
                                    }.to_json
                              })
    $a_token = info_auth.parsed_response["access_token"]
    #get_webstorms(a_token)
    redirect_to empresa_path(:token => $a_token, :empresa => $empresa)
    # render json: {"Auth": "OK"}, status: 200
  end


end
