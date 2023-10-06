# frozen_string_literal: true

class UnmuteService < BaseService
  def call(account, target_account)
    return unless account.muting?(target_account)

    account.unmute!(target_account)

    MergeJob.perform_later(target_account.id, account.id) if account.following?(target_account)
  end
end
