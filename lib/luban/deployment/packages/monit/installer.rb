module Luban
  module Deployment
    module Packages
      class Monit
        class Installer < Luban::Deployment::Service::Installer
          include Configurator::Paths

          default_executable 'monit'

          def source_repo
            @source_repo ||= "http://mmonit.com"
          end

          def source_url_root
            @source_url_root ||= "monit/dist"
          end

          def installed?
            return false unless file?(monit_executable)
            pattern = "Monit version #{package_major_version}"
            match?("#{monit_executable} -V", pattern)
          end

          def with_openssl_dir(dir)
            @configure_opts << "--with-ssl-static=#{dir}"
          end
        end
      end
    end
  end
end
