class CarrierPigeon < Sinatra::Application
	get '/messages' do
    haml :'messages/index'
  end

  get '/messages/new' do
    @title = 'Шифрування повідомлення'
    haml :'messages/new'
  end

	get '/messages/read' do
    @title = 'Розшифрування повідомлення'
		haml :'messages/show'
	end
end