module Luban
  module Deployment
    module Packages
      class Monit < Luban::Deployment::Service::Base
        apply_to :all do
          before_install do
            depend_on 'openssl', version: '1.0.2h'
          end
        end

        def default_templates_path
          @default_templates_path ||= base_templates_path(__FILE__)
        end

        %i(config_test reload_process match_process).each do |action|
          service_action action, dispatch_to: :controller
        end

        protected

        def setup_install_tasks
          super
          commands[:install].option :openssl, "OpenSSL version"
        end

        def setup_control_tasks
          super

          task :config_test do
            desc "Syntax check on control file"
            action! :config_test
          end

          task :reload do
            desc "Reload process"
            action! :reload_process
          end

          task :match do
            desc "Match process"
            argument :pattern, "Regex for process match"
            action! :match_process
          end
        end
      end
    end
  end
end
