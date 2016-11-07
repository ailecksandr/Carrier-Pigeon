require_relative '../spec_helper'

describe StrongParams do
  let(:message_params) { Hash[ body: 'sample', password: '1234', rank: 'general' ] }
  let(:params) { Hash[ id: 1, message: message_params ] }
  let(:wrong_params) { params.except(:body) }

  describe '#require' do
    it { expect(params.require(:message)).to eq message_params }
  end

  describe '#permit' do
    it { expect(message_params.permit(:body, :password, :rank)).to eq message_params }
    it { expect{ message_params.permit(:body, :password, :rank, :lvl) }.to raise_error(ArgumentError, 'Unpermitted params[:lvl]') }
    it { expect(message_params.permit(:body, :password)).to eq message_params.except!(:rank) }
  end
end