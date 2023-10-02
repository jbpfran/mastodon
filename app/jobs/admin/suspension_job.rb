# frozen_string_literal: true

class Admin::SuspensionJob < ApplicationJob
  queue_as :pull

  def perform(account_id)
    SuspendAccountService.new.call(Account.find(account_id))
  rescue ActiveRecord::RecordNotFound
    true
  end
end
