require 'sinatra'
require 'haml'
require 'sidekiq'
require 'bcrypt'
require 'sinatra/activerecord'
require 'sinatra/content_for'
require 'sinatra/config_file'
require 'sinatra/flash'
require_relative 'config/environment'
require_relative 'app/helpers/application_helper'
require_relative 'config/initializers/strong_params'

class CarrierPigeon < Sinatra::Application
	register Sinatra::ActiveRecordExtension, Sinatra::Flash
	helpers ApplicationHelper, Sinatra::ContentFor

	enable :sessions
	config_file 'config/secrets.yml'
	set :session_secret, settings.secret_key_base

	set public_folder: 'app/assets'
	set views: 'app/views'
end

require_relative 'app/routes/application'
require_relative 'app/models/application'
require_relative 'app/workers/message_destroy_worker'