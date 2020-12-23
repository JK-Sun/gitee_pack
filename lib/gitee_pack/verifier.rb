module GiteePack
  class Verifier
    def execute(from, to)
      result = system "diff -r #{from} #{to} > /dev/null 2>&1"
      message = get_message(result, from)
      [result, message]
    end

    private

    def get_message(result, file_path)
      msg = if result
              "\033[32m[OK]\033[0m"
            else
              "\033[31m[FAILED]\033[0m"
            end

      "#{file_path}\t#{msg}"
    end
  end
end
