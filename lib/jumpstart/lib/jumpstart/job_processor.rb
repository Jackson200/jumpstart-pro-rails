module Jumpstart
  class JobProcessor
    AVAILABLE_PROVIDERS = {
      "Async" => :async,
      "Sidekiq" => :sidekiq,
      "DelayedJob" => :delayed_job,
      "Sneakers" => :sneakers,
      "SuckerPunch" => :sucker_punch,
      "Que" => :que
    }.freeze

    AVAILABLE_PROVIDERS.each do |_, name|
      define_singleton_method :"#{name}?" do
        Jumpstart.config.job_processor == name
      end
    end

    def self.command(processor)
      # async, sucker_punch don't need separate processes
      case processor.to_s
      when "sidekiq"
        "bundle exec sidekiq"
      when "delayed_job"
        "bin/delayed_job --queues=default,mailers,action_mailbox_incineration,action_mailbox_routing,active_storage_analysis,active_storage_purge start"
      when "sneakers"
        "rake sneakers:run"
      when "que"
        "bundle exec que -q default -q mailers -q action_mailbox_incineration -q action_mailbox_routing -q active_storage_analysis -q active_storage_purge"
      end
    end

    def self.queue_adapter(processor)
      case processor.to_s
      when "delayed_job_active_record"
        "delayed_job"
      else
        processor.to_s
      end
    end
  end
end
