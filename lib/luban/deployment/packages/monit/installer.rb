module Luban
  module Deployment
    module Packages
      class Monit
        class Installer < Luban::Deployment::Service::Installer
          include Controller::Commands

          def without_pam?
            task.opts.without_pam
          end

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

          protected

          def configure_build_options
            super
            @configure_opts << "--without-pam" if without_pam?
          end

          def install!
            super
            # Symlink 'etc' to the profile path
            # 'etc' is the default search path for control file
            ln(profile_path, install_path.join('etc'))
          end
        end
      end
    end
  end
end
