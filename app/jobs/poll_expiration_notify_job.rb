# frozen_string_literal: true

class PollExpirationNotifyJob < ApplicationJob
  queue_as :default
  unique :until_executing

  def perform(poll_id)
    @poll = Poll.find(poll_id)

    return if does_not_expire?
    requeue! && return if not_due_yet?

    notify_remote_voters_and_owner! if @poll.local?
    notify_local_voters!
  rescue ActiveRecord::RecordNotFound
    true
  end

  def self.remove_from_scheduled(poll_id)
    queue = Sidekiq::ScheduledSet.new
    queue.select { |scheduled| scheduled.klass == name && scheduled.args[0] == poll_id }.map(&:delete)
  end

  private

  def does_not_expire?
    @poll.expires_at.nil?
  end

  def not_due_yet?
    @poll.expires_at.present? && !@poll.expired?
  end

  def requeue!
    PollExpirationNotifyJob.set(wait_until: @poll.expires_at + 5.minutes).perform_later(@poll.id)
  end

  def notify_remote_voters_and_owner!
    ActivityPub::DistributePollUpdateJob.perform_later(@poll.status.id)
    LocalNotificationJob.perform_later(@poll.account_id, @poll.id, 'Poll', 'poll')
  end

  def notify_local_voters!
    @poll.voters.merge(Account.local).select(:id).find_in_batches do |accounts|
      accounts.each do |account|
        LocalNotificationJob.perform_later(account.id, @poll.id, 'Poll', 'poll')
      end
    end
  end
end
