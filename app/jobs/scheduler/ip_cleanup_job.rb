# frozen_string_literal: true

class Scheduler::IpCleanupJob < ApplicationJob
  IP_RETENTION_PERIOD = ENV.fetch('IP_RETENTION_PERIOD', 1.year).to_i.seconds.freeze
  SESSION_RETENTION_PERIOD = ENV.fetch('SESSION_RETENTION_PERIOD', 1.year).to_i.seconds.freeze

  queue_as :scheduler
  unique :until_executed, lock_ttl: 1.day
  discard_on StandardError

  def perform
    clean_ip_columns!
    clean_expired_ip_blocks!
  end

  private

  def clean_ip_columns!
    SessionActivation.where('updated_at < ?', SESSION_RETENTION_PERIOD.ago).in_batches.destroy_all
    SessionActivation.where('updated_at < ?', IP_RETENTION_PERIOD.ago).in_batches.update_all(ip: nil) # rubocop:disable Rails/SkipsModelValidations
    User.where('current_sign_in_at < ?', IP_RETENTION_PERIOD.ago).in_batches.update_all(sign_up_ip: nil) # rubocop:disable Rails/SkipsModelValidations
    LoginActivity.where('created_at < ?', IP_RETENTION_PERIOD.ago).in_batches.destroy_all
    Doorkeeper::AccessToken.where('last_used_at < ?', IP_RETENTION_PERIOD.ago).in_batches.update_all(last_used_ip: nil) # rubocop:disable Rails/SkipsModelValidations
  end

  def clean_expired_ip_blocks!
    IpBlock.expired.in_batches.destroy_all
  end
end
