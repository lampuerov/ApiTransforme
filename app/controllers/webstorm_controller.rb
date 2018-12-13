require "json"

class WebstormController < ApplicationController

  def index

  end

  def get_webstorms
    $a_token = params[:token]
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

  private
    def webstorm_params
      params.permit(:token, :id)
    end
end
