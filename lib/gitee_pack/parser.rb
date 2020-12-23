require 'optparse'

module GiteePack
  class Parser
    def execute(args)
      options = {}
      options[:skip_asset_compile]   = false
      options[:skip_webpack_compile] = false
      OptionParser.new do |opts|
        opts.banner = 'Usage: gitee_pack BASE HEAD [options]'

        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('-S COMPILE_TYPE', '--skip-compile COMPILE_TYPE', 'Skip compile. aption: all, asset or webpack.') do |value|
          options.merge! skip_compile_options(value)
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

    def skip_compile_options(type)
      options = {}
      case type.to_s
      when 'all'
        options[:skip_asset_compile]   = true
        options[:skip_webpack_compile] = true
      when 'asset'
        options[:skip_asset_compile]   = true
      when 'webpack'
        options[:skip_webpack_compile] = true
      end
      options
    end
  end
end
