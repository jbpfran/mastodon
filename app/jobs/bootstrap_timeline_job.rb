# frozen_string_literal: true

class BootstrapTimelineJob < ApplicationJob
  queue_as :default

  def perform(account_id)
    BootstrapTimelineService.new.call(Account.find(account_id))
  end
end
