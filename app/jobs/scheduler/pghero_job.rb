# frozen_string_literal: true

class Scheduler::PgheroJob < ApplicationJob
  queue_as :scheduler
  unique :until_executed, lock_ttl: 1.day
  discard_on StandardError

  def perform
    PgHero.capture_space_stats
  end
end
