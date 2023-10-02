# frozen_string_literal: true

class Admin::DomainPurgeJob < ApplicationJob
  queue_as :pull
  unique :until_executed

  def perform(domain)
    PurgeDomainService.new.call(domain)
  end
end
