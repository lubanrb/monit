module Luban
  module Deployment
    module Packages
      class Monit
        class Controller < Luban::Deployment::Service::Controller
          module Commands
            module Public
              def monitor_control_file_name
                @monitor_control_file_name ||= 'monitrc'
              end

              def monit_command
                @monit_command ||= "#{monitor_executable} -c #{monitor_control_file_path}"
              end

              def monitor_command(service_entry)
                @monitor_command ||= shell_command("#{monit_command} monitor #{service_entry}")
              end

              def unmonitor_command(service_entry)
                @unmonitor_command ||= shell_command("#{monit_command} unmonitor #{service_entry}")
              end

              def reload_monitor_command
                @reload_monitor_command ||= shell_command("#{monit_command} reload")
              end

              def check_monitor_command(service_entry, summary: false)
                shell_command("#{monit_command} #{summary ? :summary : :status} #{service_entry}")
              end
            end

            include Public

            def self.included(base)
              base.define_executable 'monit'
            end

            def process_pattern
              @process_pattern ||= "^#{monit_command}"
            end

            def start_command
              @start_command ||= shell_command(monit_command, setup: [])
            end

            def stop_command
              @stop_command ||= shell_command("#{monit_command} quit", setup: [])
            end
          end

          include Commands

          alias_method :monitor_executable, :monit_executable
          alias_method :monitor_control_file_path, :control_file_path
          alias_method :control_file_name, :monitor_control_file_name

          def process_stopped?
            super and check_process! =~ /the monit daemon is not running$/
          end

          def process_started?
            super and check_process! =~ /^Monit #{package_major_version} uptime:|^Monit uptime:|^The Monit daemon #{package_major_version} uptime:/
          end

          %i(config_test match_process monitor_process unmonitor_process reload_process).each do |m|
            define_method(m) { update_result send("#{__method__}!") }
          end

          protected

          def config_test!
            capture(shell_command("#{monit_command} -t"))
          end

          def check_process!
            capture(check_monitor_command(task.args.service_entry, summary: task.opts.summary))
          end

          def match_process!
            capture(shell_command("#{monit_command} procmatch #{task.args.pattern}"))
          end

          def monitor_process!
            capture(monitor_command(task.args.service_entry))
          end

          def unmonitor_process!
            capture(unmonitor_command(task.args.service_entry))
          end

          def reload_process!
            capture(reload_monitor_command)
          end
        end
      end
    end
  end
end
