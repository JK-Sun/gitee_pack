module GiteePack
  class Status
    ERR_COMPILE_WEBPACK = 100
    ERR_COMPILE_ASSET   = 101
    ERR_VERIFY_PACKAGE  = 200

    class << self
      def success?(status_code)
        (!status_code.nil?) && (status_code.to_i.eql? 0)
      end
    end
  end
end
