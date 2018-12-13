require "json"

class WebstormController < ApplicationController

  def index

  end

  def get_webstorms
    $a_token = params[:token]
    url = "https://transforme.brightidea.com/api3/campaign/"
    #puts JSON.pretty_generate(response.parsed_response)
    response = HTTParty.get(url,
        {
            headers:
                {
                "Authorization" => "Bearer " + $a_token
                }
        }
        )
    info_util_webstorms = []
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

        info_util_webstorms.push(info_util)
        # info_util_webstorms[webstorm["id"]] = info_util
      end
    end
    @webs = info_util_webstorms
    # render "webstorm/index"
    # render json: JSON.pretty_generate(info_util_webstorms), status: 200
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
    info_util_ideas = {}
    if paginas > 0
      total = response.parsed_response["stats"]["total"]
      size = (total/paginas).round + 1
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
          if idea["votes"]
            idea["votes"].each do |vote|
              votos << vote["member"]["screen_name"]
            end
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
    end
    info_todo_webstorm = {"webstorm": info_util_webstorm,
                          "ideas": info_util_ideas}
    @webstorm = info_todo_webstorm
    # render json: info_todo_webstorm, status: 200
  end


  private
    def webstorm_params
      params.permit(:token, :id)
    end
end
