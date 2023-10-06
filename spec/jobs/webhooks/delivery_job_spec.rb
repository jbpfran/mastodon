# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Webhooks::DeliveryJob do
  let(:worker) { described_class.new }

  describe 'perform' do
    it 'runs without error' do
      expect { worker.perform(nil, nil) }.to_not raise_error
    end
  end
end
