# frozen_string_literal: true

# Schedule for Schked
# Example
# cron "*/30 * * * *", as: "CleanOrphanAttachmentsJob", timeout: "60s", overlap: false do
#   CleanOrphanAttachmentsJob.perform_later
# end
every '1m', as: 'indexing_scheduler' do
  Scheduler::IndexingJob.perform_later
end

cron "#{Random.rand(0..59)} #{Random.rand(6..9)} * * *", as: 'follow_recommendations_scheduler' do
  Scheduler::FollowRecommendationsJob.perform_later
end

cron "#{Random.rand(0..59)} #{Random.rand(3..5)} * * *", as: 'vacuum_scheduler' do
  Scheduler::VacuumJob.perform_later
end

cron "#{Random.rand(0..59)} #{Random.rand(4..6)} * * *", as: 'user_cleanup_scheduler' do
  Scheduler::UserCleanupJob.perform_later
end

every '5m', as: 'scheduled_statuses_scheduler' do
  Scheduler::ScheduledStatusesJob.perform_later
end

cron '0 0 * * *', as: 'pghero_scheduler' do
  Scheduler::PgheroJob.perform_later
end

cron "#{Random.rand(0..59)} #{Random.rand(3..5)} * * *", as: 'ip_cleanup_scheduler' do
  Scheduler::IpCleanupJob.perform_later
end

cron '0 * * * *', as: 'instance_refresh_scheduler' do
  Scheduler::InstanceRefreshJob.perform_later
end

every '5m', as: 'trends_refresh_scheduler' do
  Scheduler::Trends::RefreshJob.perform_later
end

every '6h', as: 'trends_review_notifications_scheduler' do
  Scheduler::Trends::ReviewNotificationsJob.perform_later
end

every '1m', as: 'accounts_statuses_cleanup_scheduler' do
  Scheduler::AccountsStatusesCleanupScheduler.perform_async
end

every '1m', as: 'suspended_user_cleanup_scheduler' do
  Scheduler::SuspendedUserCleanupScheduler.perform_async
end
