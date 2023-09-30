# frozen_string_literal: true

class TagUnmergeJob < ApplicationJob
  include DatabaseHelper

  queue_as :pull

  def perform(from_tag_id, into_account_id)
    with_primary do
      @from_tag     = Tag.find(from_tag_id)
      @into_account = Account.find(into_account_id)
    end

    with_read_replica do
      FeedManager.instance.unmerge_tag_from_home(@from_tag, @into_account)
    end
  rescue ActiveRecord::RecordNotFound
    true
  end
end
