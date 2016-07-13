require 'settingslogic'

class Settings < Settingslogic
  source File.join(Rails.root, "config", "settings.yml")
  load!

  def self.worker_queue_prefix
    "#{exchange.exchange_id}.#{exchange.environment}.q."
  end

  def self.reporting_exchange_name
    "#{exchange.exchange_id}.#{exchange.environment}.e.#{listeners.reporting_exchange.type}.#{listeners.reporting_exchange.name}"
  end

  def self.reporting_exchange_options
    {
      :type => Settings.listeners.reporting_exchange.type,
      :durable => true
    }
  end

  def self.request_exchange_name
    "#{exchange.exchange_id}.#{exchange.environment}.e.#{amqp_publishing.request_exchange.type}.#{amqp_publishing.request_exchange.name}"
  end

  def self.request_exchange_options
    {
      :type => Settings.amqp_publishing.request_exchange.type,
      :durable => true
    }
  end
end
