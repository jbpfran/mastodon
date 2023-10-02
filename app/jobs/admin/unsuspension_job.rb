# frozen_string_literal: true

class Admin::UnsuspensionJob < ApplicationJob
  queue_as :pull

  def perform(account_id)
    UnsuspendAccountService.new.call(Account.find(account_id))
  rescue ActiveRecord::RecordNotFound
    true
  end
end
