control 'nginx_installation' do
  title "nginx custom image"

  describe package('nginx') do
    it { should be_installed }
  end

  describe nginx do
    its('version') { should eq '1.10.3' }
  end

  describe systemd_service('nginx') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe systemd_service('google-fluentd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe systemd_service('stackdriver-agent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

end

