# frozen_string_literal: true

class ActivityPub::FollowersSynchronizationJob < ApplicationJob
  queue_as :push
  unique :until_executed

  def perform(account_id, url)
    @account = Account.find_by(id: account_id)
    return true if @account.nil?

    ActivityPub::SynchronizeFollowersService.new.call(@account, url)
  end
end
