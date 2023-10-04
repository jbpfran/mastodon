# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PollExpirationNotifyJob do
  let(:worker) { described_class.new }
  let(:account) { Fabricate(:account, domain: remote? ? 'example.com' : nil) }
  let(:status) { Fabricate(:status, account: account) }
  let(:poll) { Fabricate(:poll, status: status, account: account) }
  let(:remote?) { false }
  let(:poll_vote) { Fabricate(:poll_vote, poll: poll) }

  describe '#perform' do
    around do |example|
      Sidekiq::Testing.fake! do
        example.run
      end
    end

    it 'runs without error for missing record' do
      expect { worker.perform(nil) }.to_not raise_error
    end

    # context 'when poll is not expired' do
    #  it 'requeues job' do
    #    worker.perform(poll.id)
    #    expect(described_class.sidekiq_options_hash['lock']).to be :until_executing
    #    expect(described_class).to have_enqueued_sidekiq_job(poll.id).at(poll.expires_at + 5.minutes)
    #  end
    # end
  end
end
