# frozen_string_literal: true

class UnfavouriteService < BaseService
  include Payloadable

  def call(account, status)
    favourite = Favourite.find_by!(account: account, status: status)
    favourite.destroy!
    create_notification(favourite) if !status.account.local? && status.account.activitypub?
    favourite
  end

  private

  def create_notification(favourite)
    status = favourite.status
    ActivityPub::DeliveryJob.perform_later(build_json(favourite), favourite.account_id, status.account.inbox_url)
  end

  def build_json(favourite)
    Oj.dump(serialize_payload(favourite, ActivityPub::UndoLikeSerializer))
  end
end
