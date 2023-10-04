# frozen_string_literal: true

class ActivityPub::AccountRawDistributionJob < ActivityPub::RawDistributionJob
  protected

  def inboxes
    @inboxes ||= AccountReachFinder.new(@account).inboxes
  end
end
