module GiteePack
  class Worker
    def initialize(base, head, options = {})
      @options = GiteePack::Parser.new.execute(options[:ARGV])
      @base    = base
      @head    = head
      @diff    = Diff.new(@base, @head)
      @errors  = []
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

      verify_upgrade_package
    end

    private

    def compile_webpack_files_and_cp
      if process_webpack?
        Precompile.with_webpack
        unless GiteePack::Status.success?($?)
          exit GiteePack::Status::ERR_COMPILE_WEBPACK
        end

        Filer.cp_webpack_files
      end
    end

    def compile_asset_files_and_cp
      if process_asset?
        Precompile.with_asset
        unless GiteePack::Status.success?($?)
          exit GiteePack::Status::ERR_COMPILE_ASSET
        end

        Filer.cp_asset_files
      end
    end

    def verify_upgrade_package
      GiteePack.logger.info '[Verifying] package is verifying, please wait ...'

      verify_digest_with_cp_files
      verify_digest_with_webpacks_dir
      verify_digest_with_assets_dir

      unless @errors.empty?
        exit GiteePack::Status::ERR_VERIFY_PACKAGE
      end
    end

    def verify_digest_with_cp_files
      @diff.cp_files.each do |file|
        from = File.join(Folder.upgrade_files_dir, file)
        to = file
        result, message = GiteePack::Verifier.new.execute(from, to)
        GiteePack.logger.debug message
        set_errors(result, message) unless result
      end
    end

    def verify_digest_with_webpacks_dir
      if process_webpack?
        from = File.join(GiteePack::Folder.upgrade_files_dir, GiteePack::Folder.webpacks_dir)
        to = GiteePack::Folder.webpacks_dir
        result, message = GiteePack::Verifier.new.execute(from, to)
        GiteePack.logger.debug message
        set_errors(result, message) unless result
      end
    end

    def verify_digest_with_assets_dir
      if process_asset?
        from = File.join(GiteePack::Folder.upgrade_files_dir, GiteePack::Folder.assets_dir)
        to = GiteePack::Folder.assets_dir
        result, message = GiteePack::Verifier.new.execute(from, to)
        GiteePack.logger.debug message
        set_errors(result, message) unless result
      end
    end

    def process_webpack?
      !@options[:skip_webpack_compile] && @diff.has_webpack_file?
    end

    def process_asset?
      !@options[:skip_asset_compile] && @diff.has_asset_file?
    end

    def set_errors(result, message)
      @errors << { result: result, message: message }
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
