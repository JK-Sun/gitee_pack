require 'fileutils'

module GiteePack
  class Folder
    class << self
      def mkdir_upgrade
        rm_dir(upgrade_dir)
        FileUtils.mkdir_p(upgrade_files_dir)
        puts "mkdir #{upgrade_dir}"
        puts "mkdir #{upgrade_files_dir}"
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
          puts "rm -rf #{dir}"
        end
      end
    end
  end
end
