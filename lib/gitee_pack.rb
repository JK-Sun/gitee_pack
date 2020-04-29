require 'fileutils'

require 'gitee_pack/version'
require 'gitee_pack/diff'
require 'gitee_pack/folder'
require 'gitee_pack/filer'
require 'gitee_pack/precompile'
require 'gitee_pack/worker'

module GiteePack
  class CmdError < StandardError; end

  def self.execute(base, head, options = {})
    Worker.new(base, head).execute
  end
end
