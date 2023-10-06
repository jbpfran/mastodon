# frozen_string_literal: true

class RemoteAccountRefreshJob < ApplicationJob
  include JsonLdHelper

  queue_as :pull
  retry_on StandardError, attempts: 3, wait: :exponentially_longer

  def perform(id)
    account = Account.find_by(id: id)
    return if account.nil? || account.local?

    ActivityPub::FetchRemoteAccountService.new.call(account.uri)
  rescue Mastodon::UnexpectedResponseError => e
    response = e.response

    raise e unless response_error_unsalvageable?(response)
    # Give up
  end
end
