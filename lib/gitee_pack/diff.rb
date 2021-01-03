module GiteePack
  class Diff
    attr_reader :empty_folders, :delete_files, :cp_files,
                :webpack_files, :asset_files, :gem_files

    IGNORE_FILES = [
      'config/gitee.yml',
      'config/database.yml',
      'config/startup.yml',
      'app/assets/javascripts/webpack/webide'
    ].freeze

    def initialize(base, head)
      @base          = base
      @head          = head
      @empty_folders = []
      @delete_files  = []
      @cp_files      = []
      @webpack_files = []
      @asset_files   = []
      @gem_files     = []

      init_list_by_files
    end

    def diff_files
      result = `git diff #{@base} #{@head} --name-only`
      raise CmdError, 'cmd error' if result.empty?

      result.split("\n")
    end

    def diff_files_with_status
      result = `git diff #{@base} #{@head} --name-status`
      raise CmdError, 'cmd error' if result.empty?

      result.split("\n")
    end

    def has_webpack_file?
      !webpack_files.empty?
    end

    def has_asset_file?
      !asset_files.empty?
    end

    def has_gem_file?
      !gem_files.empty?
    end

    private

    def init_list_by_files
      init_empty_folders_and_cp_files
      init_delete_files
    end

    def init_delete_files
      @delete_files = diff_files_with_status.map do |file|
        file.sub("D\t", '') if file.start_with?('D')
      end.compact
    end

    def init_empty_folders_and_cp_files
      diff_files.each do |file|
        next if IGNORE_FILES.include?(file)

        if file.start_with?('app/assets/javascripts/webpack')
          @webpack_files << file
        elsif file.start_with?('app/assets')
          @asset_files << file
        elsif file.start_with?('Gemfile')
          @gem_files << file
        end

        if Dir.exist?(file)
          @empty_folders << file
          next
        end

        next unless File.exist?(file)

        @cp_files << file
      end
    end
  end
end
