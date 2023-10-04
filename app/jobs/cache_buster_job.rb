# frozen_string_literal: true

class CacheBusterJob < ApplicationJob
  include RoutingHelper

  queue_as :pull

  def perform(path)
    cache_buster.bust(full_asset_url(path))
  end

  private

  def cache_buster
    CacheBuster.new(Rails.configuration.x.cache_buster)
  end
end
