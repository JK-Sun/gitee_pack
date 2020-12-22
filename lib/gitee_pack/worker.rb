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

      compile_webpack_files_and_cp
      compile_asset_files_and_cp

      Filer.g_diff_file(@diff.diff_files_with_status)
      Filer.g_delete_file(@diff.delete_files)
      Filer.g_commit_file(["old: #{@base}", "new: #{@head}"])
      Filer.cp_update_file

      puts_empty_folders
      puts_deleted_files
    end

    private

    def compile_webpack_files_and_cp
      if @diff.has_webpack_file?
        Precompile.with_webpack
        unless GiteePack::Status.success?($?)
          exit GiteePack::Status::ERR_COMPILE_WEBPACK
        end

        Filer.cp_webpack_files
      end
    end

    def compile_asset_files_and_cp
      if @diff.has_asset_file?
        Precompile.with_asset
        unless GiteePack::Status.success?($?)
          exit GiteePack::Status::ERR_COMPILE_ASSET
        end

        Filer.cp_asset_files
      end
    end

    def puts_deleted_files
      unless @diff.delete_files.empty?
        GiteePack.logger.warn "\nDelete Files:"
        GiteePack.logger.warn "#{@diff.delete_files.join("\n")}"
      end
    end

    def puts_empty_folders
      unless @diff.empty_folders.empty?
        GiteePack.logger.warn "\nEmpty Folders:"
        GiteePack.logger.warn "#{@diff.empty_folders.join("\n")}"
      end
    end
  end
end
