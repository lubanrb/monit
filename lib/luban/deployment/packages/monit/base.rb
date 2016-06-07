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
          @default_templates_path ||= Pathname.new(File.join(File.dirname(__FILE__), 'templates')).realpath
        end

        service_action :config_test, dispatch_to: :controller
        service_action :reload_process, dispatch_to: :controller

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
        end
      end
    end
  end
end
