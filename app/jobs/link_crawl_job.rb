# frozen_string_literal: true

class LinkCrawlJob < ApplicationJob
  queue_as :pull
  discard_on ActiveRecord::RecordNotFound

  def perform(status_id)
    FetchLinkCardService.new.call(Status.find(status_id))
  rescue ActiveRecord::RecordNotFound
    true
  end
end
