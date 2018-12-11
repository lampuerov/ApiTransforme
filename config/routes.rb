Rails.application.routes.draw do
	get '/', to: 'api/api#token'
end
