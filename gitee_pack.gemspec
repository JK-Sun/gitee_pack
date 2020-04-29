require_relative 'lib/gitee_pack/version'

Gem::Specification.new do |spec|
  spec.name          = "gitee_pack"
  spec.version       = GiteePack::VERSION
  spec.authors       = ["jk-sun"]
  spec.email         = ["jk-sun@qq.com"]

  spec.summary       = %q{It's incremental packager for Gitee Premium.}
  spec.homepage      = "https://github.com/JK-Sun/gitee_pack"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = ["gitee_pack"]
  spec.require_paths = ["lib"]
end
