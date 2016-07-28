require 'nobrainer'

require_relative 'models/webpage'

NoBrainer.configure do |config|
  config.app_name = 'varys'
  config.environment = ENV['RACK_ENV']
  config.driver = :regular
  config.logger = config.default_logger
  config.colorize_logger = true
  config.table_options = \
    { :shards => 1, :replicas => 1, :write_acks => :majority }
  config.max_string_length = 255
  config.user_timezone = :local
  config.db_timezone = :utc
  config.distributed_lock_class = "NoBrainer::Lock"
  config.lock_options = { :expire => 60, :timeout => 10 }
  config.per_thread_connection = false
  config.machine_id = config.default_machine_id
  config.criteria_cache_max_entries = 10_000
end
