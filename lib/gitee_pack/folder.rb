require 'fileutils'

module GiteePack
  class Folder
    class << self
      def mkdir_upgrade
        rm_dir(upgrade_dir)
        FileUtils.mkdir_p(upgrade_files_dir)
        GiteePack.logger.debug "mkdir #{upgrade_dir}"
        GiteePack.logger.debug "mkdir #{upgrade_files_dir}"
      end

      def upgrade_dir
        @upgrade_dir ||= "upgrade-#{Time.now.strftime('%Y%m%d')}"
      end

      def upgrade_files_dir
        @upgrade_files_dir ||= File.join(upgrade_dir, 'files')
      end

      def rm_dir(dir)
        if Dir.exist?(dir)
          `rm -rf #{dir}`
          GiteePack.logger.debug "rm -rf #{dir}"
        end
      end

      def webpacks_dir
        'public/webpacks/'
      end

      def assets_dir
        'public/assets/'
      end
    end
  end
end
