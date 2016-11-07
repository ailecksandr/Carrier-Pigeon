require_relative '../spec_helper'

describe CarrierPigeon do
  def app
    CarrierPigeon
  end

  let(:message_attributes) { FactoryGirl.attributes_for(:message) }
  let(:empty_message_attributes) { FactoryGirl.attributes_for(:empty_message) }
  let(:message) { FactoryGirl.create(:message, message_attributes) }
  let(:expiring_message) { FactoryGirl.create(:expiring_message) }
  let(:message_with_last_review) { FactoryGirl.create(:message_with_last_review) }

  describe '/messages' do
    before { get '/messages' }

    it { expect(last_response.body).to include('Send messages to your friend secure') }
  end

  describe '/messages/new' do
    before { get '/messages/new' }

    it { expect(last_response.body).to include('Creating encrypted message') }
  end

  describe '/messages/search' do
    before { get '/messages/search' }

    it { expect(last_response.body).to include('Searching encrypted message') }
  end

  describe '/messages/?:token?' do
    context 'GET' do
      before { @proc = ->(token) { get "/message/#{token}" } }

      context 'success' do
        before { @proc.call(message.token) }

        it { expect(last_response.body).to include('Decrypting message') }
      end

      context 'error' do
        before { @proc.call('937-99-92'); follow_redirect! }

        it { expect(last_response.body).to include('Searching message') }
        it { expect(last_response.body).to include('There are not such a message.') }
      end
    end

    context 'POST' do
      before { @proc = ->(token, password) { post "/message/#{token}", message: { password: password } } }

      context 'success' do
        context 'default message' do
          before { @proc.call(message.token, '12345678') }

          it { expect(message.reload.destroy_value).to eq 4 }
          it { expect(last_response.body).to include('4 reviews remaining') }
          it { expect(last_response.body).to include('Message') }
        end

        context 'message with last review' do

          it { message_with_last_review; expect{ @proc.call(message_with_last_review.token, '12345678') }.to change(Message, :count).by(-1) }
          it { @proc.call(message_with_last_review.token, '12345678'); expect(last_response.body).to include('That was a last review') }
        end

        context 'expiring message' do
          before { @proc.call(expiring_message.token, '12345678') }

          it { expect(expiring_message.destroy_value).to eq 5 }
          it { expect(last_response.body).to include('Message will be destroyed') }
        end
      end

      context 'error' do
        before { @proc.call(message.token, '1234'); follow_redirect! }

        it { expect(last_response.body).to include('Wrong password.') }
        it { expect(last_response.body).to include('Decrypting message') }
      end
    end
  end

  describe '/message/encrypt' do
    before { @proc = ->(message_params) { post '/messages/encrypt', message: message_params } }

    context 'success' do
      it { @proc.call(message_attributes); expect(last_response.body).to include('Token of your message') }
      it { expect{ @proc.call(message_attributes) }.to change(Message, :count).by(1) }
      it { @proc.call(message_attributes); expect(last_response.body).to include Message.last.token }
    end

    context 'error' do
      context 'flashes' do
        before { @proc.call(empty_message_attributes); follow_redirect! }

        it { expect(last_response.body).to include('Body can\'t be blank') }
        it { expect(last_response.body).to include('Password can\'t be blank.') }
        it { expect(last_response.body).to include('Creating encrypted message') }
      end

      it { expect{ @proc.call(empty_message_attributes) }.to_not change(Message, :count) }
    end
  end
end
