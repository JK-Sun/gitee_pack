module GiteePack
  class Logger
    def debug(content)
      puts content
    end

    def info(content)
      puts "\033[36m#{content}\033[0m"
    end

    def warn(content)
      puts "\033[33m#{content}\033[0m"
    end

    def error(content)
      puts "\033[31m#{content}\033[0m"
    end

    def success(content)
      puts "\033[32m#{content}\033[0m"
    end
  end
end
