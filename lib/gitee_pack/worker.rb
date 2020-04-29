module GiteePack
  class Worker
    def initialize(base, head)
      @base = base
      @head = head
      @diff = Diff.new(@base, @head)
    end

    def execute
      Folder.mkdir_upgrade
      Filer.cp_diff_files(@diff.cp_files)

      if @diff.precompile?
        Precompile.with_webpack
        Filer.cp_webpack_files
      end

      Filer.g_diff_file(@diff.diff_files_with_status)
      Filer.g_delete_file(@diff.delete_files)

      puts_empty_folders
      puts_delete_files
    end

    private

    def puts_delete_files
      unless @diff.delete_files.empty?
        puts "\n\033[33mDelete Files:\n"
        puts "#{@diff.delete_files.join("\n")}\033[0m"
      end
    end

    def puts_empty_folders
      unless @diff.empty_folders.empty?
        puts "\n\033[33mEmpty Folders:\n"
        puts "#{@diff.empty_folders.join("\n")}\033[0m"
      end
    end
  end
end
