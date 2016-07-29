Rails.eager_load!

PID_FILE_LOCATION = File.join(File.expand_path(File.join(File.dirname(__FILE__), "..")), "pids", "sneakers.pid")
SNEAKERS_RUNNER_CONFIG = File.join(File.expand_path(File.join(File.dirname(__FILE__), "..")), "config", "sneakers.conf.rb")

require 'sneakers/runner'

Sneakers.configure(
  :amqp => Settings.amqp_uri,
  :start_worker_delay => 0.2,
  :heartbeat => 5,
  :log => STDOUT,
  :pid_path => PID_FILE_LOCATION,
  :runner_config_file => SNEAKERS_RUNNER_CONFIG,
)
Sneakers.logger.level = Logger::INFO

runner = Sneakers::Runner.new([HbxEnrollmentDatabaseSink])
runner.run
