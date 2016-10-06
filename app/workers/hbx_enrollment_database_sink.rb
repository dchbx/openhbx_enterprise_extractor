require "sneakers/handlers/maxretry"

class HbxEnrollmentDatabaseSink
  include Sneakers::Worker

  from_queue self.queue_name,
    :ack => true,
    :prefetch => 5,
    :threads => 5,
    :exchange => Settings.reporting_exchange_name,
    :exchange_options => Settings.reporting_exchange_options,
    :routing_key => "hbx_enrollment.xml_extracted",
    :handler => Sneakers::Handlers::Maxretry,
    :retry_timeout => 5000,
    :heartbeat => 5,
    :arguments => {
      :'x-dead-letter-exchange' => self.retry_exchange_name
    }

    def self.retry_exchange_name
      queue_name + "-retry"
    end

    def self.queue_name
      Settings.worker_queue_prefix + "openhbx_enterprise_extractor.hbx_enrollment_database_sink"
    end

    def work_with_params(msg, delivery_info, properties)
      begin
        headers = properties.headers || {}
        policy_id = headers["policy_id"]
        return_status = headers["return_status"].to_s
        case return_status
        when "200"
          the_xml = Nokogiri::XML(msg)
          HbxEnrollmentRecord.store(policy_id, XmlHasherizer.serialize(the_xml.root))
        when "404"
        else
        end
        ack!
      rescue Exception => ex
        new_error = WorkerError.new(ex.message)
        new_error.set_backtrace(ex.backtrace)
        raise new_error
      end
    end
end
