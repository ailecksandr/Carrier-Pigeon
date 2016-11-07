class CarrierPigeon < Sinatra::Application
  get '/' do
    haml :'messages/index'
  end

  not_found do
    haml :'layout/404', layout: false
  end
end

require_relative 'messages'