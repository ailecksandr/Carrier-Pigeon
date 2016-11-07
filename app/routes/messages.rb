require_relative '../../lib/strong_params'

class CarrierPigeon < Sinatra::Application
  get '/messages' do
    haml :'messages/index'
  end

  get '/messages/new' do
    haml :'messages/new'
  end

  get '/messages/search' do
    haml :'messages/search'
  end

  get '/message/?:token?' do
    @message = Message.find_by_token(params[:token])

    if @message
      haml :'messages/decrypt'
    else
      flash[:error] = 'There are not such a message.'
      redirect :'messages/search'
    end
  end

  post '/message/:token' do
    @message = Message.find_by_token(params[:token])

    if @message.with_password?(params[:message][:password])
      @message_attributes = @message.update_state!
      haml :'messages/show'
    else
      flash[:error] = 'Wrong password.'
      redirect :"message/#{@message.token}"
    end
  end

  post '/messages/encrypt' do
    @message = Message.new(message_params)

    if @message.save
      haml :'messages/success'
    else
      flash[:error] = @message.errors.full_messages
      redirect :'messages/new'
    end
  end


  private


  def message_params
    params.require(:message).permit(:body, :password, :destroy_type, :destroy_value)
  end
end