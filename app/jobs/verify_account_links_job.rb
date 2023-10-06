# frozen_string_literal: true

class VerifyAccountLinksJob < ApplicationJob
  queue_as :default
  unique :until_executed
  discard_on ActiveRecord::RecordNotFound

  def perform(account_id)
    account = Account.find(account_id)

    account.fields.each do |field|
      VerifyLinkService.new.call(field) if field.requires_verification?
    end

    account.save! if account.changed?
  rescue ActiveRecord::RecordNotFound
    true
  end
end
