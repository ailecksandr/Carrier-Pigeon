require_relative '../spec_helper'
require 'byebug'

describe Message do
  let(:message) { FactoryGirl.create(:message) }
  let(:expiring_attrs) { FactoryGirl.attributes_for(:expiring_message) }
  let(:last_review_attrs) { FactoryGirl.attributes_for(:message_with_last_review) }
  let(:empty_message) { FactoryGirl.create(:empty_message) }
  let(:expiring_message) { FactoryGirl.create(:message, expiring_attrs) }
  let(:message_with_last_review) { FactoryGirl.create(:message, last_review_attrs) }

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

    context 'after create' do
      before do
        expect(MessageDestroyWorker).to receive(:perform_in)
        expiring_message
        Timecop.freeze(Time.now + expiring_message.destroy_value.seconds)
      end

      it { expect{ expiring_message.reload }.to change(Message, :count).by(-1) }

      after { Timecop.return }
    end
  end

  context 'methods' do
    describe '#with_password?' do
      it { expect(message.with_password? '12345678').to eq true }
      it { expect(message.with_password? '1234').to eq false }
    end

    describe '#update_state!' do
      before do
        message_with_last_review
        expiring_message
      end

      it { expect(message_with_last_review.update_state![:body]).to eq last_review_attrs[:body] }
      it { expect{ message_with_last_review.update_state! }.to change(Message, :count).by(-1) }
      it { expect{ expiring_message.update_state! }.not_to change(Message, :count) }
    end
  end
end
