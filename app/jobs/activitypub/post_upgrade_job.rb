# frozen_string_literal: true

class ActivityPub::PostUpgradeJob < ApplicationJob
  queue_as :pull

  def perform(domain)
    Account.where(domain: domain)
           .where(protocol: :ostatus)
           .where.not(last_webfingered_at: nil)
           .in_batches
           .update_all(last_webfingered_at: nil) # rubocop:disable Rails/SkipsModelValidations
  end
end
