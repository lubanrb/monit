module Luban
  module Deployment
    module Packages
      class Monit
        class Configurator < Luban::Deployment::Service::Configurator
          def control_file_name
            @control_file_name ||= 'monitrc'
          end

          def state_file_path
            @state_file_path ||= pids_path.join(state_file_name)
          end

          def state_file_name
            @state_file_name ||= "#{service_name}.state"
          end

          def id_file_path
            @id_file_path ||= pids_path.join(id_file_name)
          end

          def id_file_name
            @id_file_name ||= "#{service_name}.id"
          end

          def services_path
            @services_path ||= env_path.join("#{stage}.*").join("*").join("shared").
                                        join('profile').join('*')
          end

          def update_profile
            super
            chmod('700', stage_profile_path.join('monitrc'))
          end
        end
      end
    end
  end
end