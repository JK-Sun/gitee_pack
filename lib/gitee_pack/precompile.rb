module GiteePack
  class Precompile
    class << self
      def with_webpack
        GiteePack.logger.info '[Compiling] webpack files is compiling, please wait ...'
        Folder.rm_dir('public/webpacks')
        cmd = 'npm run build-vendor && npm run f-build'
        GiteePack.logger.debug cmd
        `#{cmd}`
      end

      def with_asset
        GiteePack.logger.info '[Compiling] asset files is compiling, please wait ...'
        Folder.rm_dir('public/assets')
        cmd = 'RAILS_ENV=production bundle exec rake assets:precompile'
        GiteePack.logger.debug cmd
        `#{cmd}`
      end
    end
  end
end
