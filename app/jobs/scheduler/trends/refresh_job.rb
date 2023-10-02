# frozen_string_literal: true

class Scheduler::Trends::RefreshJob < ApplicationJob
  queue_as :scheduler

  discard_on StandardError

  def perform
    Trends.refresh!
  end
end
