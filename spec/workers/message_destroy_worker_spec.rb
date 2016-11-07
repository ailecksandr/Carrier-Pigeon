require_relative '../spec_helper'

describe MessageDestroyWorker do
  let(:message) { FactoryGirl.create(:message) }

  context 'modules' do
    it { is_expected.to be_kind_of(Sidekiq::Worker) }
  end

  describe '#perform' do
    before do
      @worker = MessageDestroyWorker.new
      message
    end

    it { expect{ @worker.perform(message.id) }.to change(Message, :count).by(-1) }
  end
end