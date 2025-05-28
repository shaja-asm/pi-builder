require 'serverspec'
require 'net/ssh'

set :backend, :ssh

host = ENV['BOARD']
unless host
  fail "No BOARD env with the target address given!"
end
port = ENV['PORT']

options = Net::SSH::Config.for(host)

options[:user] ||= 'pirate'
options[:password] ||= 'hypriot'
if port
  options[:port] = port
end

set :host,        options[:host_name] || host
set :ssh_options, options

# expose expected tool versions via RSpec configuration
RSpec.configure do |config|
  config.add_setting :docker_compose_version, default: ENV['DOCKER_COMPOSE_VERSION']
  config.add_setting :docker_machine_version, default: ENV['DOCKER_MACHINE_VERSION']
  config.add_setting :docker_ce_version,      default: ENV['DOCKER_CE_VERSION']
end
