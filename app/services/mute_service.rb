# frozen_string_literal: true

class MuteService < BaseService
  def call(account, target_account, notifications: nil, duration: 0)
    return if account.id == target_account.id

    mute = account.mute!(target_account, notifications: notifications, duration: duration)

    if mute.hide_notifications?
      BlockJob.perform_later(account.id, target_account.id)
    else
      MuteJob.perform_later(account.id, target_account.id)
    end

    DeleteMuteJob.set(wait: duration.seconds).perform_later(mute.id) if duration != 0

    mute
  end
end
