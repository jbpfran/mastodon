# frozen_string_literal: true

class ActivityPub::SynchronizeFeaturedTagsCollectionJob < ApplicationJob
  queue_as :pull
  unique :until_executed

  def perform(account_id, url)
    ActivityPub::FetchFeaturedTagsCollectionService.new.call(Account.find(account_id), url)
  rescue ActiveRecord::RecordNotFound
    true
  end
end
