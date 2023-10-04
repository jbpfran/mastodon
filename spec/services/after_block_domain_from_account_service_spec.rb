# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AfterBlockDomainFromAccountService, type: :service do
  subject { described_class.new }

  let!(:wolf) { Fabricate(:account, username: 'wolf', domain: 'evil.org', inbox_url: 'https://evil.org/inbox', protocol: :activitypub) }
  let!(:alice) { Fabricate(:account, username: 'alice') }

  before do
    stub_jsonld_contexts!
    allow(ActivityPub::DeliveryJob).to receive(:perform_later)
  end

  it 'purge followers from blocked domain' do
    wolf.follow!(alice)
    subject.call(alice, 'evil.org')
    expect(wolf.following?(alice)).to be false
  end

  it 'sends Reject->Follow to followers from blocked domain' do
    wolf.follow!(alice)
    subject.call(alice, 'evil.org')
    expect(ActivityPub::DeliveryJob).to have_received(:perform_later).once
  end
end
