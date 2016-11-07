require_relative '../spec_helper'

describe ApplicationHelper do
  describe '#title' do
    it { expect(title).to eq 'Carrier Pigeon' }
    it { expect(title 'Performing smth').to eq 'Carrier Pigeon | Performing smth' }
  end

  describe '#options_for_radio_buttons' do
    before do
      @hash = {
        reviewing: 'By reviews',
        expiring: 'By ellapsed hours'
      }
    end

    it { expect(options_for_radio_buttons).to eq @hash }
  end

  describe '#reviews_info' do
    it { expect(reviews_info(0)).to eq 'That was a last review' }
    it { expect(reviews_info(1)).to eq '1 reviews remaining' }
  end

  describe '#expiring_info' do
    before { @date = DateTime.new(2016, 11, 14, 1, 2, 1) }

    it { expect(expiring_info(@date, 13)).to eq 'Message will be destroyed 14 November at 14:02' }
  end

  describe '#flash_class' do
    it { expect(flash_class :error).to eq 'alert alert-danger' }
    it { expect(flash_class :notice).to eq 'alert alert-info' }
  end

  describe '#errors_list' do
    before do
      @errors = %w(error1 error2)
    end

    it { expect(errors_list(@errors)).to eq '<p>error1;</p><p>error2.</p>' }
    it { expect(errors_list([@errors[0]])).to eq '<p>error1.</p>' }
    it { expect(errors_list(@errors[0])).to eq 'error1' }
  end
end
