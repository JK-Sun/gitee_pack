module GiteePack
  class Precompile
    class << self
      def with_webpack
        Folder.rm_dir('public/webpacks')
        `npm run build-vendor && npm run f-build`
      end
    end
  end
end
