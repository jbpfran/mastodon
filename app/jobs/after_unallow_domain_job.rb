# frozen_string_literal: true

class AfterUnallowDomainJob < ApplicationJob
  queue_as :default

  def perform(domain)
    AfterUnallowDomainService.new.call(domain)
  end
end
