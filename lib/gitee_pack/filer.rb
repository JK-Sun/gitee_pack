module GiteePack
  class Filer
    class << self
      def cp_diff_files(files)
        files.each do |file|
          from = file
          to   = File.join(Folder.upgrade_files_dir, File.dirname(file))
          cp_file from, to
        end
      end

      def cp_webpack_files
        from = File.join(Folder.webpacks_dir, '.')
        to   = File.join(Folder.upgrade_files_dir, Folder.webpacks_dir)
        cp_file from, to
      end

      def cp_asset_files
        from = File.join(Folder.assets_dir, '.')
        to   = File.join(Folder.upgrade_files_dir, Folder.assets_dir)
        cp_file from, to
      end

      def cp_gems
        from = File.join(Folder.bundle_cache_dir, '.')
        to   = File.join(Folder.upgrade_files_dir, Folder.bundle_cache_dir)
        cp_file from, to
      end

      def cp_update_file
        from = File.join(File.expand_path('../../../', __FILE__), 'exe/update.sh')
        to   =  Folder.upgrade_dir
        cp_file from, to
      end

      def cp_file(from, to)
        FileUtils.mkdir_p to
        GiteePack.logger.debug "cp -r #{from} #{to}"
        FileUtils.cp_r from, to
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

      def g_log_file(content= [])
        g_file(File.join(Folder.upgrade_dir, 'run.log'), content)
      end
    end
  end
end
