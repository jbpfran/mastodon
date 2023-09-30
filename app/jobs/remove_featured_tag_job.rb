# frozen_string_literal: true

class RemoveFeaturedTagJob < ApplicationJob
  queue_as :default

  def perform(account_id, featured_tag_id)
    RemoveFeaturedTagService.new.call(Account.find(account_id), FeaturedTag.find(featured_tag_id))
  rescue ActiveRecord::RecordNotFound
    true
  end
end
