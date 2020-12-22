module GiteePack
  class Precompile
    class << self
      def with_webpack
        GiteePack.logger.info '[Compiling] webpack files is compiling, please wait ...'
        Folder.rm_dir('public/webpacks')
        `npm run build-vendor && npm run f-build`
      end

      def with_asset
        GiteePack.logger.info '[Compiling] asset files is compiling, please wait ...'
        Folder.rm_dir('public/assets')
        `bundle exec rake assets:precompile:all RAILS_ENV=production RAILS_GROUPS=assets`
      end
    end
  end
end
