module GiteePack
  class Worker
    def initialize(base, head, options = {})
      @options = Parser.new.execute(options[:ARGV])
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
      compile_gems_and_cp

      Filer.g_diff_file(@diff.diff_files_with_status)
      Filer.g_delete_file(@diff.delete_files)
      Filer.g_commit_file(["old: #{@base}", "new: #{@head}"])
      Filer.cp_update_file

      puts_empty_folders
      puts_deleted_files

      verify_upgrade_package

      Filer.g_log_file GiteePack.logger.history
    end

    private

    def compile_webpack_files_and_cp
      if process_webpack?
        Precompile.with_webpack
        unless Status.success?($?)
          Filer.g_log_file GiteePack.logger.history
          exit Status::ERR_COMPILE_WEBPACK
        end

        Filer.cp_webpack_files
      end
    end

    def compile_asset_files_and_cp
      if process_asset?
        Precompile.with_asset
        unless Status.success?($?)
          Filer.g_log_file GiteePack.logger.history
          exit Status::ERR_COMPILE_ASSET
        end

        Filer.cp_asset_files
      end
    end

    def compile_gems_and_cp
      if process_gem?
        Precompile.with_gem
        unless Status.success?($?)
          Filer.g_log_file GiteePack.logger.history
          exit Status::ERR_COMPILE_GEM
        end

        Filer.cp_gems
      end
    end

    def verify_upgrade_package
      GiteePack.logger.info '[Verifying] package is verifying, please wait ...'

      verify_digest_with_cp_files
      verify_digest_with_webpacks_dir
      verify_digest_with_assets_dir
      verify_digest_with_gems_dir

      unless @errors.empty?
        Filer.g_log_file GiteePack.logger.history
        exit Status::ERR_VERIFY_PACKAGE
      end
    end

    def verify_digest_with_cp_files
      @diff.cp_files.each do |file|
        from = File.join(Folder.upgrade_files_dir, file)
        to = file
        verify_files from, to
      end
    end

    def verify_digest_with_webpacks_dir
      if process_webpack?
        from = File.join(Folder.upgrade_files_dir, Folder.webpacks_dir)
        to = Folder.webpacks_dir
        verify_files from, to
      end
    end

    def verify_digest_with_assets_dir
      if process_asset?
        from = File.join(Folder.upgrade_files_dir, Folder.assets_dir)
        to = Folder.assets_dir
        verify_files from, to
      end
    end

    def verify_digest_with_gems_dir
      if process_gem?
        from = File.join(Folder.upgrade_files_dir, Folder.bundle_cache_dir)
        to = Folder.bundle_cache_dir
        verify_files from, to
      end
    end

    def verify_files(from, to)
      result, message = Verifier.new.execute(from, to)
      GiteePack.logger.debug message
      set_errors(result, message) unless result
    end

    def process_webpack?
      !@options[:skip_webpack_compile] && @diff.has_webpack_file?
    end

    def process_asset?
      !@options[:skip_asset_compile] && @diff.has_asset_file?
    end

    def process_gem?
      !@options[:skip_gem_compile] && @diff.has_gem_file?
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
