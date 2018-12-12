require 'json'


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
    $a_token = info_auth.parsed_response["access_token"]
    #get_webstorms(a_token)
    render json: {"Auth": "OK"}, status: 200
  end

  def get_webstorms
    url = "https://transforme.brightidea.com/api3/campaign/"
    #p response
    #puts JSON.pretty_generate(response.parsed_response)
    response = HTTParty.get(url,
        {
            headers:
                {
                "Authorization" => "Bearer " + $a_token
                }
        }
        )
    info_util_webstorms = {}
    paginas = response.parsed_response["stats"]["page_count"]
    total = response.parsed_response["stats"]["total"]
    size = (total/paginas).round + 1
    (1..paginas).each do |pg|
      response = HTTParty.get(url + "?page=" + pg.to_s + "&page_size=" + size.to_s,
          {
              headers:
                  {
                  "Authorization" => "Bearer " + $a_token
                  }
          }
          )
      webstorms = response.parsed_response["campaign_list"]
      webstorms.each do |webstorm|
        info_util = {"id": webstorm["id"],
                     "webstorm": webstorm["name"],
                     "descripcion": webstorm["description"],
                     "fecha_creacion": webstorm["date_created"],
                     "fecha_inicio": webstorm["start_date"],
                     "fecha_fin": webstorm["end_date"],
                     "estado": webstorm["status"],
                     "calendario": webstorm["scheduled"],
                     "sponsor": webstorm["sponsor"]["screen_name"]
                   }

        #info_util_webstorms << info_util
        info_util_webstorms[webstorm["id"]] = info_util
      end
    end
    render json: JSON.pretty_generate(info_util_webstorms), status: 200
  end
end
