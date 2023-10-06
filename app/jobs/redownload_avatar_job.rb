# frozen_string_literal: true

class RedownloadAvatarJob < ApplicationJob
  include JsonLdHelper

  queue_as :pull
  retry_on StandardError, attempts: 7, wait: :exponentially_longer

  def perform(id)
    account = Account.find(id)

    return if account.suspended? || DomainBlock.rule_for(account.domain)&.reject_media?
    return if account.avatar_remote_url.blank? || account.avatar_file_name.present?

    account.reset_avatar!
    account.save!
  rescue ActiveRecord::RecordNotFound
    # Do nothing
  rescue Mastodon::UnexpectedResponseError => e
    response = e.response

    raise e unless response_error_unsalvageable?(response)
    # Give up
  end
end
