# frozen_string_literal: true

class RedownloadMediaJob < ApplicationJob
  include JsonLdHelper

  queue_as :pull
  retry_on StandardError, attempts: 3, wait: :exponentially_longer

  def perform(id)
    media_attachment = MediaAttachment.find(id)

    return if media_attachment.remote_url.blank?

    media_attachment.download_file!
    media_attachment.download_thumbnail!
    media_attachment.save
  rescue ActiveRecord::RecordNotFound
    # Do nothing
  rescue Mastodon::UnexpectedResponseError => e
    response = e.response

    raise e unless response_error_unsalvageable?(response)
    # Give up
  end
end
