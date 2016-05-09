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

        protected

        def setup_control_tasks
          super
          undef_task :monitor
          undef_task :unmonitor
        end
      end
    end
  end
end