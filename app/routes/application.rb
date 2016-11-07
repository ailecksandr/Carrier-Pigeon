class CarrierPigeon < Sinatra::Application
  get '/' do
    haml :'messages/index'
  end

  not_found do
    haml :'layout/404'
  end
end

require_relative 'messages'