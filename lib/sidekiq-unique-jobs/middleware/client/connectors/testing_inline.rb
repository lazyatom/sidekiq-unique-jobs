require 'sidekiq-unique-jobs/middleware/client/connectors/connector'

module SidekiqUniqueJobs
  module Middleware
    module Client
      module Connectors
        class TestingInline < Connector
          def self.eligible?(redis_pool = nil)
            Config.testing_enabled? && Sidekiq::Testing.inline?
          end

          def review_unique
            Server::UniqueJobs.new.call(worker_class.new, item, queue, redis_pool) do
              super
            end
          end

          private

          def conn
            SidekiqUniqueJobs.redis_mock { |conn| conn }
          end
        end
      end
    end
  end
end