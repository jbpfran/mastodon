# frozen_string_literal: true

class ResolveAccountJob < ApplicationJob
  queue_as :pull
  unique :until_executed

  def perform(uri)
    ResolveAccountService.new.call(uri)
  end
end
