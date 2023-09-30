# frozen_string_literal: true

class AccountMergingJob < ApplicationJob
  queue_as :pull

  def perform(account_id)
    account = Account.find(account_id)

    return true if account.nil? || account.local?

    Account.where(uri: account.uri).where.not(id: account.id).find_each do |duplicate|
      account.merge_with!(duplicate)
      duplicate.destroy
    end
  end
end
