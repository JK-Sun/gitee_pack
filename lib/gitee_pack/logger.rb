module GiteePack
  class Logger
    attr_accessor :history

    def initialize
      @history = []
    end

    def debug(content)
      logging content
    end

    def info(content)
      logging "\033[36m#{content}\033[0m"
    end

    def warn(content)
      logging "\033[33m#{content}\033[0m"
    end

    def error(content)
      logging "\033[31m#{content}\033[0m"
    end

    def success(content)
      logging "\033[32m#{content}\033[0m"
    end

    private

    def logging(content)
      set_history content
      puts content
    end

    def set_history(content)
      @history << content
    end
  end
end
