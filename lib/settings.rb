require 'settingslogic'

class Settings < Settingslogic
  source File.join(Rails.root, "config", "settings.yml")
  load!

  def self.worker_queue_prefix
    "#{exchange.exchange_id}.#{exchange.environment}.q."
  end
end
