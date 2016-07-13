class HbxEnrollmentExtractor
  include Sneakers::Worker
  include AmqpUtils::MessagePublisher

  from_queue self.queue_name,
    :ack => true,
    :prefetch => 5,
    :threads => 5,
    :exchange => Settings.reporting_exchange_name,
    :exchange_options => Settings.reporting_exchange_options,
    :routing_key => "info.events.policy.updated",
    :handler => Sneakers::Handlers::Oneshot,
    :heartbeat => 5

  def self.queue_name
    Settings.worker_queue_prefix + "openhbx_enterprise_extractor.hbx_enrollment_extractor"
  end

  def work_with_params(msg, delivery_info, props)
    headers = properties.headers || {}
    enrollment_id = headers["hbx_enrollment_id"]
    with_confirmed_channel do |ch|
      rex = ch.exchange(Settings.request_exchange_name, Settings.request_exchange_options)
      reply_to = HbxEnrollmentDatabaseSink.queue_name
      rex.publish("", 
                  {
                    :routing_key => "resource.policy",
                    :reply_to => reply_to,
                    :headers => {
                      :policy_id => enrollment_id
                    }
                  }
      )
    end
    ack!
  end
end
