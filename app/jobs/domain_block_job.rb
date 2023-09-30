# frozen_string_literal: true

class DomainBlockJob < ApplicationJob
  queue_as :default

  def perform(domain_block_id, update: false)
    domain_block = DomainBlock.find_by(id: domain_block_id)
    return true if domain_block.nil?

    BlockDomainService.new.call(domain_block, update)
  end
end
