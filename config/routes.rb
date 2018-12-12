Rails.application.routes.draw do
	get '/', to: 'api/api#token'

	get '/web', to: 'webstorm#index'

end
