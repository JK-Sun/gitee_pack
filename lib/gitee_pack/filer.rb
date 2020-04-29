module GiteePack
  class Filer
    class << self
      def cp_diff_files(files)
        files.each do |file|
          dirname = File.join(Folder.upgrade_files_dir, File.dirname(file))
          FileUtils.mkdir_p dirname
          FileUtils.cp file, dirname
          puts "cp #{file} #{dirname}"
        end
      end

      def cp_webpack_files
        dirname = File.join(Folder.upgrade_files_dir, 'public/webpacks')
        FileUtils.mkdir_p dirname
        FileUtils.cp_r 'public/webpacks/.', dirname
        puts "cp -r public/webpacks/. #{dirname}"
      end

      def g_file(path, content = [])
        File.open(path, 'w') do |f|
          f.write("#{content.join("\n")}\n")
        end
      end

      def g_delete_file(content = [])
        g_file(File.join(Folder.upgrade_dir, 'delete.txt'), content)
      end

      def g_diff_file(content = [])
        g_file(File.join(Folder.upgrade_dir, 'diff.txt'), content)
      end
    end
  end
end
