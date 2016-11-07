require_relative '../spec_helper'

describe Message, type: :model do
  let(:message) { FactoryGirl.create(:message) }
  let(:empty_message) { FactoryGirl.create(:empty_message) }
  let(:expiring_message) { FactoryGirl.create(:expiring_message) }
  let(:message_with_last_review) { FactoryGirl.create(:message_with_last_review) }

  context 'modules' do
    it { is_expected.to be_kind_of(BCrypt) }
  end

  context 'validations' do
    it { expect(message).to validate_presence_of(:body) }
    it { expect(message).to validate_presence_of(:password) }
    it { expect(message).to validate_presence_of(:destroy_type) }
    it { expect(message).to validate_presence_of(:destroy_value) }
    it { is_expected.to define_enum_for(:destroy_type).with(%w(reviewing expiring)) }
    it { expect(message).to validate_uniqueness_of(:token) }
  end

  context 'callbacks' do
    it { expect(message.password).not_to eq '12345678' }
    it { expect(message.token).not_to eq nil }
    it { expect(MessageDestroyWorker).to receive(:perform_in); expiring_message }
  end

  context 'methods' do
    describe '#with_password?' do
      it { expect(message.with_password? '12345678').to eq true }
      it { expect(message.with_password? '1234').to eq false }
    end

    describe '#update_state!' do
      before do
        @with_last_review_domain = message_with_last_review.clone
        expiring_message
      end

      it { expect((message_with_last_review.update_state!).body).to eq @with_last_review_domain.body }
      it { expect{ message_with_last_review.update_state! }.to change(Message, :count).by(-1) }
      it { expect{ expiring_message.update_state! }.not_to change(Message, :count) }
    end
  end
end
