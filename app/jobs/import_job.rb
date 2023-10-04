# frozen_string_literal: true

class ImportJob < ApplicationJob
  queue_as :pull
  retry_on StandardError, attempts: 0

  def perform(import_id)
    import = Import.find(import_id)
    ImportService.new.call(import)
  ensure
    import&.destroy
  end
end
