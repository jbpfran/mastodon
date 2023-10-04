# frozen_string_literal: true

class ActivityPub::FetchRepliesJob < ApplicationJob
  queue_as :pull
  retry_on StandardError, attempts: 3, wait: :exponentially_longer

  def perform(parent_status_id, replies_uri, options = {})
    ActivityPub::FetchRepliesService.new.call(Status.find(parent_status_id), replies_uri, **options.deep_symbolize_keys)
  rescue ActiveRecord::RecordNotFound
    true
  end
end
