require 'json'


class Array
  def comprehend(&block)
    return self if block.nil?
    self.collect(&block).compact
  end
end

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
                                      :username => "gjara@transforme.cl",
                                      :password => "Workhard2017"
                                    }.to_json
                              })
    $a_token = info_auth.parsed_response["access_token"]
    #get_webstorms(a_token)
    render json: {"Auth": "OK"}, status: 200
  end

  def get_webstorms
    url = "https://transforme.brightidea.com/api3/campaign/"
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
        info_util_webstorms[webstorm["id"]] = info_util
      end
    end
    render json: JSON.pretty_generate(info_util_webstorms), status: 200
  end

  def get_webstorm
    id_web = params["id"]
    url = "https://transforme.brightidea.com/api3/campaign/"+ id_web +"?with=idea_count"
    response = HTTParty.get(url,
        {
            headers:
                {
                "Authorization" => "Bearer " + $a_token
                }
        }
        )
    webstorm = response.parsed_response["campaign"]
    info_util_webstorm = {"id": webstorm["id"],
                 "webstorm": webstorm["name"],
                 "descripcion": webstorm["description"],
                 "fecha_creacion": webstorm["date_created"],
                 "fecha_inicio": webstorm["start_date"],
                 "fecha_fin": webstorm["end_date"],
                 "estado": webstorm["status"],
                 "calendario": webstorm["scheduled"],
                 "sponsor": webstorm["sponsor"]["screen_name"],
                 "cantidad_ideas": webstorm["idea_count"],
                 "cantidad_comentarios": webstorm["comment_count"],
                 "cantidad_votos": webstorm["vote_count"],
                 "cantidad_miembros": webstorm["member_count"],
                 "cantidad_blogs": webstorm["blog_count"]
               }
    # Obteniendo ideas del webstorm
    url = "https://transforme.brightidea.com/api3/idea?campaign_id=" + id_web
    response = HTTParty.get(url,
         {
             headers:
                 {
                 "Authorization" => "Bearer " + $a_token
                 }
         }
         )
    paginas = response.parsed_response["stats"]["page_count"]
    total = response.parsed_response["stats"]["total"]
    size = (total/paginas).round + 1
    info_util_ideas = {}
    (1..paginas).each do |pg|
     response = HTTParty.get(url + "&page=" + pg.to_s + "&page_size=" + size.to_s,
         {
             headers:
                 {
                 "Authorization" => "Bearer " + $a_token
                 }
         }
         )
     ideas = response.parsed_response["idea_list"]
     ideas.each do |idea|
       votos = []
       idea["votes"].each do |vote|
         votos << vote["member"]["screen_name"]
       end
       info_util = {"id": idea["id"],
                    "fecha_creacion": idea["date_created"],
                    "titulo": idea["title"],
                    "descripcion": idea["description"],
                    "puntaje": idea["score"],
                    "puntaje_actual": idea["step_score"],
                    "cantidad_votos": idea["vote_count"],
                    "votos": votos,
                    "autor": idea["member"]["screen_name"],
                    "autor_email": idea["member"]["email"],
                    "categoria": idea["category"]["name"]
                  }
       info_util_ideas[idea["id"]] = info_util
     end
    end
    info_todo_webstorm = {"webstorm": info_util_webstorm,
                          "ideas": info_util_ideas}
    render json: info_todo_webstorm, status: 200
  end

end
