module GiteePack
  class Precompile
    class << self
      def with_webpack
        Folder.rm_dir('public/webpacks')
        GiteePack.logger.info 'webpack files is compiling, please wait ...'
        `npm run build-vendor && npm run f-build`
      end

      def with_asset
        Folder.rm_dir('public/assets')
        GiteePack.logger.info 'asset files is compiling, please wait ...'
        `bundle exec rake assets:precompile:all RAILS_ENV=production RAILS_GROUPS=assets`
      end
    end
  end
end
