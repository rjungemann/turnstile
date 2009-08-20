dir = File.dirname(__FILE__)

require "#{dir}/utils/generate"
require "#{dir}/model/turnstile"
require "#{dir}/model/user"
require "#{dir}/model/realm"
require "#{dir}/model/role"

$t = Turnstile::Model::Turnstile.new
Turnstile::Model::Turnstile.init