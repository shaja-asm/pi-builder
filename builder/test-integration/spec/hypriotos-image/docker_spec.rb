require 'spec_helper'

describe package('docker-engine') do
  it { should_not be_installed }
end

describe package('docker-ce') do
  it { should be_installed }
end

package_version = RSpec.configuration.docker_ce_version

describe command('dpkg -l docker-ce') do
  its(:stdout) { should match /ii  docker-ce/ }
  if package_version
    its(:stdout) { should match /#{Regexp.escape(package_version)}/ }
  else
    its(:stdout) { should match /24.0.5~ce~3-0~debian/ }
  end
  its(:stdout) { should match /armhf/ }
  its(:exit_status) { should eq 0 }
end

describe file('/usr/bin/docker') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/usr/bin/docker-containerd') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/usr/bin/docker-containerd-ctr') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/usr/bin/docker-containerd-shim') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/usr/bin/docker-runc') do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file('/lib/systemd/system/docker.socket') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file('/var/run/docker.sock') do
  it { should be_socket }
  it { should be_mode 660 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'docker' }
end

describe file('/etc/default/docker') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file('/var/lib/docker') do
  it { should be_directory }
  it { should be_mode 711 }
  it { should be_owned_by 'root' }
end

describe file('/var/lib/docker/overlay2') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'root' }
end

describe file('/etc/bash_completion.d/docker') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_file }
end

docker_version =
  if package_version
    ver = package_version.split(':').last
    ver = ver.split('~').first
    "#{ver}-ce"
  else
    '24.0.5-ce'
  end

describe command('docker -v') do
  its(:stdout) { should match /Docker version #{Regexp.escape(docker_version)}, build/ }
  its(:exit_status) { should eq 0 }
end

describe command('docker version') do
  its(:stdout) { should match /Client:. Version:        #{Regexp.escape(docker_version)}. API version:        1.37/m }
  its(:stdout) { should match /Server:. Engine:.  Version:      #{Regexp.escape(docker_version)}.  API version:       1.37/m }
  its(:exit_status) { should eq 0 }
end

describe command('docker info') do
  its(:stdout) { should match /Storage Driver: overlay/ }
  its(:exit_status) { should eq 0 }
end

describe interface('lo') do
  it { should exist }
end

describe interface('docker0') do
  it { should exist }
end

describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end

describe command('grep docker /var/log/syslog') do
  its(:stdout) { should match /Daemon has completed initialization/ }
  its(:exit_status) { should eq 0 }
end
