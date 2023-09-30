# frozen_string_literal: true

class DomainClearMediaJob < ApplicationJob
  queue_as :pull

  def perform(domain_block_id)
    domain_block = DomainBlock.find_by(id: domain_block_id)
    return true if domain_block.nil?

    ClearDomainMediaService.new.call(domain_block)
  end
end
