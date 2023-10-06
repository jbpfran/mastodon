# frozen_string_literal: true

class DistributionJob < ApplicationJob
  include Redisable
  include Lockable

  queue_as :default

  def perform(status_id, options = {})
    with_redis_lock("distribute:#{status_id}") do
      FanOutOnWriteService.new.call(Status.find(status_id), **options.symbolize_keys)
    end
  rescue ActiveRecord::RecordNotFound
    true
  end
end
