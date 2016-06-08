module Luban
  module Deployment
    module Packages
      class Monit
        class Controller < Luban::Deployment::Service::Controller
          default_executable 'monit'

          def monit_command
            @monit_command ||= "#{monit_executable}"
          end
          alias_method :process_pattern, :monit_command

          def process_stopped?
            super and check_process! =~ /the monit daemon is not running$/
          end

          def process_started?
            super and check_process! =~ /^The Monit daemon #{package_major_version} uptime:|^Monit uptime:/
          end

          def config_test
            update_result config_test!
          end

          def reload_process
            update_result reload_process!
          end

          def match_process
            update_result match_process!
          end

          protected

          def config_test!
            capture("#{monit_command} -t 2>&1")
          end

          def start_process!
            capture("#{monit_command} 2>&1")
          end

          def stop_process!
            capture("#{monit_command} quit 2>&1")
          end

          def check_process!
            capture("#{monit_command} status 2>&1")
          end

          def reload_process!
            capture("#{monit_command} reload 2>&1")
          end

          def match_process!
            capture("#{monit_command} procmatch #{task.args.pattern} 2>&1")
          end
        end
      end
    end
  end
end