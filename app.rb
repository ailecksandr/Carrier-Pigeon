require 'sinatra'
require 'haml'
require_relative 'config/environment'
require_relative 'helpers/application_helper'
require 'sinatra/form_helpers'

class CarrierPigeon < Sinatra::Application
	helpers ApplicationHelper, Sinatra::FormHelpers

	set public_folder: 'assets'
	set stylesheets: %w(layout)
	set javascripts: %w()
end

require_relative 'models/init'
require_relative 'routes/init'