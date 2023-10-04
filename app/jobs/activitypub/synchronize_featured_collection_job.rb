# frozen_string_literal: true

class ActivityPub::SynchronizeFeaturedCollectionJob < ApplicationJob
  queue_as :pull
  unique :until_executed

  def perform(account_id, options = {})
    options = { note: true, hashtag: false }.deep_merge(options.deep_symbolize_keys)

    ActivityPub::FetchFeaturedCollectionService.new.call(Account.find(account_id), **options)
  rescue ActiveRecord::RecordNotFound
    true
  end
end
