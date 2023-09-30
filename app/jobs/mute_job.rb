# frozen_string_literal: true

class MuteJob < ApplicationJob
  queue_as :default

  def perform(account_id, target_account_id)
    FeedManager.instance.clear_from_home(Account.find(account_id), Account.find(target_account_id))
  rescue ActiveRecord::RecordNotFound
    true
  end
end
