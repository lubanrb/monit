module Luban
  module Deployment
    module Packages
      class Monit
        class Controller < Luban::Deployment::Service::Controller
          module Commands
            def self.included(base)
              base.define_executable 'monit'
            end

            def monit_command
              @monit_command ||= "#{monit_executable}"
            end

            def process_pattern
              @process_pattern ||= "^#{monit_command}"
            end

            def start_command
              @start_command ||= shell_command(monitor_command)
            end

            def stop_command
              @stop_command ||= shell_command("#{monit_command} quit")
            end
          end

          include Commands

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
            capture(shell_command("#{monit_command} -t"))
          end

          def check_process!
            capture(shell_command("#{monit_command} status"))
          end

          def reload_process!
            capture(shell_command("#{monit_command} reload"))
          end

          def match_process!
            capture(shell_command("#{monit_command} procmatch #{task.args.pattern}"))
          end
        end
      end
    end
  end
end
