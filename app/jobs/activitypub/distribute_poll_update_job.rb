# frozen_string_literal: true

class ActivityPub::DistributePollUpdateJob < ApplicationJob
  include Payloadable

  queue_as :push
  unique :until_executed
  discard_on StandardError

  def perform(status_id)
    @status  = Status.find(status_id)
    @account = @status.account

    return unless @status.preloadable_poll

    inboxes.in_batches.each do |inbox_url|
      ActivityPub::DeliveryJob.perform_later(payload, @account.id, inbox_url)
    end

    relay! if relayable?
  rescue ActiveRecord::RecordNotFound
    true
  end

  private

  def relayable?
    @status.public_visibility?
  end

  def inboxes
    return @inboxes if defined?(@inboxes)

    @inboxes = [@status.mentions, @status.reblogs, @status.preloadable_poll.votes].flat_map do |relation|
      relation.includes(:account).map do |record|
        record.account.preferred_inbox_url if !record.account.local? && record.account.activitypub?
      end
    end

    @inboxes.concat(@account.followers.inboxes) unless @status.direct_visibility?
    @inboxes.uniq!
    @inboxes.compact!
    @inboxes
  end

  def payload
    @payload ||= Oj.dump(serialize_payload(@status, ActivityPub::UpdatePollSerializer, signer: @account))
  end

  def relay!
    Relay.enabled.pluck(:inbox_url).each do |inbox_url|
      ActivityPub::DeliveryJob.perform_later(payload, @account.id, inbox_url)
    end
  end
end
