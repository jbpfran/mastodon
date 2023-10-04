# frozen_string_literal: true

class BulkImportJob < ApplicationJob
  queue_as :pull
  discard_on StandardError

  def perform(import_id)
    import = BulkImport.find(import_id)
    import.update!(state: :in_progress)
    BulkImportService.new.call(import)
  end
end
