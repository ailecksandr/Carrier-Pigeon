require_relative '../spec_helper'

describe CarrierPigeon do
  def app
    CarrierPigeon
  end

  describe '/' do
    before { get '/' }

    it { expect(last_response.status).to eq 200 }
    it { expect(last_response.body).to include('Send messages to your friend secure') }
  end

  describe 'not_found' do
    before { get '/fail_path' }

    it { expect(last_response.status).to eq 404 }
    it { expect(last_response.body).to include('Page came to the horizon') }
  end
end