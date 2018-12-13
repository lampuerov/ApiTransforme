require "json"

class WebstormController < ApplicationController

  $empresa = "transforme"

  def index

  end

  def get_webstorms
    $a_token = params[:token]
    url = "https://#{$empresa}.brightidea.com/api3/campaign/"
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
    url = "https://#{$empresa}.brightidea.com/api3/campaign/"+ id_web +"?with=idea_count"
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
    url = "https://#{$empresa}.brightidea.com/api3/idea?campaign_id=" + id_web
    response = HTTParty.get(url,
         {
             headers:
                 {
                 "Authorization" => "Bearer " + $a_token
                 }
         }
         )
    paginas = response.parsed_response["stats"]["page_count"]
    info_util_ideas = []
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
          p idea
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
                      "autor_id": idea["member"]["id"],
                      "autor": idea["member"]["screen_name"],
                      "autor_email": idea["member"]["email"],
                      "categoria": idea["category"]["name"]
                    }
        info_util_ideas.push(info_util)
        # info_util_ideas[idea["id"]] = info_util
        end
      end
    end
    info_todo_webstorm = {"webstorm": info_util_webstorm,
                          "ideas": info_util_ideas}
    @webstorm = info_todo_webstorm
    @ideas = @webstorm[:ideas]
    # render json: info_todo_webstorm, status: 200
  end

  def get_user
    id_lider = params["id"]
    url = "https://#{$empresa}.brightidea.com/api3/member/" + id_lider + "?with=groups"
    response = HTTParty.get(url,
        {
            headers:
                {
                "Authorization" => "Bearer " + $a_token
                }
        }
        )
    grupos = response.parsed_response["member"]["groups"]
    p response.parsed_response

    @groups = grupos
    @user = response.parsed_response["member"]
    # if grupos.length() == 1
    #   url = "https://#{$empresa}.brightidea.com/api3/group/"+ grupos[0]["id"] +"?with=members&with=member_count"
    #   response = HTTParty.get(url,
    #       {
    #           headers:
    #               {
    #               "Authorization" => "Bearer " + $a_token
    #               }
    #       }
    #       )
    #   grupo = response.parsed_response
    #   p "GGGGGGGGGGGGRRRRRRRRRRRRRRRUUUUUUUUUUUUUUUPPPPPPPPPOOOOOOOOOOOOSSSSSSSS"
    #   p grupo
    #   miembros = grupo["group"]["members"]
    #   miembros_util = []
    #   miembros.each do |miembro|
    #     m = {}
    #     m["id"] = miembro["id"]
    #     m["nombre"] = miembro["screen_name"]
    #     m["email"] = miembro["email"]
    #     m["fecha_ultimo_login"] = miembro["last_login_date"]
    #     miembros_util << m
    #   end
    #   info_util = {"id_grupo": grupo["group"]["id"],
    #                "nombre_grupo": grupo["group"]["group_name"],
    #                "miembros": miembros_util}
    #   render json: info_util, status: 200
    # else
    #   url = "https://#{$empresa}.brightidea.com/api3/member"
    #   info_grupos = []
    #   grupos.each do |grupo|
    #     p "GRUPO Número: " + grupo["id"]
    #     #p grupo["id"]
    #     url2 = url + "?group_id=" + grupo["id"]
    #     response = HTTParty.get(url2,
    #         {
    #             headers:
    #                 {
    #                 "Authorization" => "Bearer " + $a_token
    #                 }
    #         }
    #         )
    #     miembros = response.parsed_response["member_list"]
    #     miembros_util = []
    #     miembros.each do |miembro|
    #       m = {}
    #       m["nombre"] = miembro["screen_name"]
    #       m["email"] = miembro["email"]
    #       m["fecha_ultimo_login"] = miembro["last_login_date"]
    #       miembros_util << m
    #     end
    #     info_grupos << {"id_grupo": grupo["id"], "grupo": grupo["group_name"], "miembros": miembros_util}
    #   end
    #   #je = id_miembros("FA338C98-5E7D-4516-8ED6-724139B00F9B")
    #   render json: info_grupos, status: 200
    # end
  end


  private
    def webstorm_params
      params.permit(:token, :id)
    end
end
