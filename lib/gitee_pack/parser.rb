require 'optparse'

module GiteePack
  class Parser
    def execute(args)
      options = default_options
      OptionParser.new do |opts|
        opts.banner = 'Usage: gitee_pack BASE HEAD [options]'

        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('--skip-compile-asset', 'Skip compile asset.') do
          options[:skip_asset_compile] = true
        end

        opts.on('--skip-compile-webpack', 'Skip compile webpack.') do
          options[:skip_webpack_compile] = true
        end

        opts.on('--skip-package-gem', 'Skip package gem.') do
          options[:skip_gem_compile] = true
        end

        opts.on_tail('-h', '--help', 'Show this message.') do
          GiteePack.logger.debug opts
          exit
        end

        opts.on_tail('-v', '--version', 'Show version info.') do
          GiteePack.logger.debug "Version: #{GiteePack::VERSION}"
          exit
        end
      end.parse!(args)

      options
    end

    private

    def default_options
      {
        skip_asset_compile:   false,
        skip_webpack_compile: false,
        skip_gem_compile:     false
      }
    end
  end
end
