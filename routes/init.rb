class CarrierPigeon < Sinatra::Application
  get '/' do
    haml :'messages/index'
  end
end

require_relative 'message'