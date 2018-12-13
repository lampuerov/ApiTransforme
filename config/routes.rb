Rails.application.routes.draw do
	get '/', to: 'api/api#token'

	get '/web', to: 'webstorm#index'

	# get '/web/:id', to: 'webstorm#show'

	get '/webs', to: 'webstorm#get_webstorms'

	# get '/webstorms', to: 'api/api#get_webstorms'
end
