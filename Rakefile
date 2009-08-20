# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

namespace :tmp do
  desc "Remove all temporary files."
  task :clean do
    sh "sudo rm -rf pkg tmp"
  end
end

ensure_in_path 'lib'
require 'turnstile'

task :default => 'spec:run'

PROJ.name = 'turnstile'
PROJ.authors = 'Roger Jungemann'
PROJ.email = 'roger@thefifthcircuit.com'
PROJ.url = 'http://thefifthcircuit.com'
PROJ.version = Turnstile::VERSION
PROJ.rubyforge.name = 'turnstile'

PROJ.spec.opts << '--color'

depend_on 'moneta'
depend_on 'uuid'
depend_on 'andand'

# EOF
