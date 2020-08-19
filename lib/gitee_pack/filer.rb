module GiteePack
  class Filer
    class << self
      def cp_diff_files(files)
        files.each do |file|
          dirname = File.join(Folder.upgrade_files_dir, File.dirname(file))
          FileUtils.mkdir_p dirname
          FileUtils.cp file, dirname
          GiteePack.logger.debug "cp #{file} #{dirname}"
        end
      end

      def cp_webpack_files
        dirname = File.join(Folder.upgrade_files_dir, 'public/webpacks')
        FileUtils.mkdir_p dirname
        FileUtils.cp_r 'public/webpacks/.', dirname
        GiteePack.logger.debug "cp -r public/webpacks/. #{dirname}"
      end

      def cp_asset_files
        dirname = File.join(Folder.upgrade_files_dir, 'public/assets')
        FileUtils.mkdir_p dirname
        FileUtils.cp_r 'public/assets/.', dirname
        GiteePack.logger.debug "cp -r public/assets/. #{dirname}"
      end

      def cp_update_file
        filepath = File.join(File.expand_path('../../../', __FILE__), 'exe/update.sh')
        FileUtils.cp filepath, Folder.upgrade_dir
        GiteePack.logger.debug "cp #{filepath} #{Folder.upgrade_dir}"
      end

      def g_file(path, content = [])
        File.open(path, 'w') do |f|
          f.write("#{content.join("\n")}\n")
        end unless content.empty?
      end

      def g_delete_file(content = [])
        g_file(File.join(Folder.upgrade_dir, 'delete.txt'), content)
      end

      def g_diff_file(content = [])
        g_file(File.join(Folder.upgrade_dir, 'diff.txt'), content)
      end

      def g_commit_file(content = [])
        g_file(File.join(Folder.upgrade_dir, 'commit.txt'), content)
      end
    end
  end
end
