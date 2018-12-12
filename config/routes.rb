Rails.application.routes.draw do
	get '/', to: 'api/api#token'

	get '/web', to: 'webstorm#index'

	get '/webstorms', to: 'api/api#get_webstorms'
end
