module Luban
  module Deployment
    module Packages
      class Monit
        class Controller < Luban::Deployment::Service::Controller
          include Configurator::Paths

          default_executable 'monit'

          def monit_command
            @monit_command ||= "#{monit_executable} -c #{control_file_path}"
          end

          def process_stopped?
            check_process! =~ /the monit daemon is not running$/
          end

          def process_started?
            check_process! =~ /^The Monit daemon #{package_major_version} uptime:/
          end

          undef_method :monitor_process
          undef_method :unmonitor_process

          protected

          def start_process!
            capture("#{monit_command} 2>&1")
          end

          def stop_process!
            capture("#{monit_command} quit 2>&1")
          end

          def check_process!
            capture("#{monit_command} status 2>&1")
          end
        end
      end
    end
  end
end