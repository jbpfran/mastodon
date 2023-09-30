# frozen_string_literal: true

class DeleteMuteJob < ApplicationJob
  queue_as :default

  def perform(mute_id)
    mute = Mute.find_by(id: mute_id)
    UnmuteService.new.call(mute.account, mute.target_account) if mute&.expired?
  end
end
