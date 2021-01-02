module GiteePack
  class Precompile
    class << self
      def with_webpack
        GiteePack.logger.info '[Compiling] webpack files is compiling, please wait ...'
        Folder.rm_dir(Folder.webpacks_dir)
        cmd = 'npm run build-vendor && npm run f-build'
        GiteePack.logger.debug cmd
        `#{cmd}`
      end

      def with_asset
        GiteePack.logger.info '[Compiling] asset files is compiling, please wait ...'
        Folder.rm_dir(Folder.assets_dir)
        cmd = 'RAILS_ENV=production bundle exec rake assets:precompile'
        GiteePack.logger.debug cmd
        `#{cmd}`
      end

      def with_gem
        GiteePack.logger.info '[Compiling] gems is compiling, please wait ...'
        Folder.rm_dir(Folder.bundle_cache_dir)
        cmd = 'bundle package --all'
        GiteePack.logger.debug cmd
        `#{cmd}`
      end
    end
  end
end
