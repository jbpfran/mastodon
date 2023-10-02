# frozen_string_literal: true

class Scheduler::Trends::ReviewNotificationsJob < ApplicationJob
  queue_as :scheduler
  discard_on StandardError

  def perform
    Trends.request_review!
  end
end
