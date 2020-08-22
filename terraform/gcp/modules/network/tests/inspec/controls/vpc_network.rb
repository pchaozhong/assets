title 'network module test'

gcp_project_id = attribute('gcp_project_id')

control 'test' do
  describe google_compute_network(project: gcp_project_id, name: 'test') do
    it {should exist}
    its ('auto_create_subnetworks'){ should be false}
  end
  describe google_compute_subnetwork(project: gcp_project_id, region: 'asia-northeast1', name: 'test') do
    it { should exist }
    its('ip_cidr_range') { should eq '192.168.0.0/29' }
    its('log_config.enable') { should be false}
  end
  describe google_compute_firewall(project: gcp_project_id, name: 'test') do
    it { should_not network 'https://www.googleapis.com/compute/v1/projects/ca-kitano-study-sandbox/global/networks/test'}
  end
end
