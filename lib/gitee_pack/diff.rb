module GiteePack
  class Diff
    attr_reader :empty_folders, :delete_files, :cp_files

    def initialize(base, head)
      @base          = base
      @head          = head
      @precompile    = false
      @empty_folders = []
      @delete_files  = []
      @cp_files      = []

      init_diff_status
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

    def precompile?
      @precompile
    end

    private

    def init_diff_status
      diff_files.each do |file|
        if file.start_with?('app/assets/javascripts/webpack')
          @precompile = true
        end

        if Dir.exist?(file)
          @empty_folders << file
          next
        end

        unless File.exist?(file)
          @delete_files << file
          next
        end

        @cp_files << file
      end
    end
  end
end
