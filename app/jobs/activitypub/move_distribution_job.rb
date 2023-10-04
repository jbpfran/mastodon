# frozen_string_literal: true

class ActivityPub::MoveDistributionJob < ApplicationJob
  include Payloadable

  queue_as :push

  def perform(migration_id)
    @migration = AccountMigration.find(migration_id)
    @account   = @migration.account

    inboxes.in_batches.each do |inbox_url|
      ActivityPub::DeliveryJob.perform_later(signed_payload, @account.id, inbox_url)
    end

    Relay.enabled.pluck(:inbox_url).each do |inbox_url|
      ActivityPub::DeliveryJob.perform_later(signed_payload, @account.id, inbox_url)
    end
  rescue ActiveRecord::RecordNotFound
    true
  end

  private

  def inboxes
    @inboxes ||= (@migration.account.followers.inboxes + @migration.account.blocked_by.inboxes).uniq
  end

  def signed_payload
    @signed_payload ||= Oj.dump(serialize_payload(@migration, ActivityPub::MoveSerializer, signer: @account))
  end
end
