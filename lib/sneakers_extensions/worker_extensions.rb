module SneakersExtensions
  module WorkerExtensions
    def connection
      queue.connection
    end
  end
end
