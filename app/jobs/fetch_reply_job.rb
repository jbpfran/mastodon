# frozen_string_literal: true

class FetchReplyJob < ApplicationJob
  queue_as :pull
  retry_on StandardError, attempts: 3, wait: :exponentially_longer

  def perform(child_url, options = {})
    FetchRemoteStatusService.new.call(child_url, **options.deep_symbolize_keys)
  end
end
