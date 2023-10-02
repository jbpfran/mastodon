# frozen_string_literal: true

class Scheduler::InstanceRefreshJob < ApplicationJob
  queue_as :scheduler
  unique :until_executed, lock_ttl: 1.day
  discard_on StandardError

  def perform
    Instance.refresh
    InstancesIndex.import if Chewy.enabled?
  end
end
