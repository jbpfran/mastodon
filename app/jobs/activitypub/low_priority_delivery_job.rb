# frozen_string_literal: true

class ActivityPub::LowPriorityDeliveryJob < ActivityPub::DeliveryJob
  queue_as :pull
  retry_on StandardError, attempts: 8
end
