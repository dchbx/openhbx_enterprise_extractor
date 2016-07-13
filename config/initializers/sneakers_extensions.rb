require "sneakers"
require "sneakers_extensions/queue_extensions"
require "sneakers_extensions/worker_extensions"

Sneakers::Queue.class_eval do
  include SneakersExtensions::QueueExtensions
end

Sneakers::Worker.module_eval do
  include SneakersExtensions::WorkerExtensions
end
