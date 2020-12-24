title 'network module test'

gcp_project_id = attribute('gcp_project_id')
networks = yaml(content: inspec.profile.file('vpc_network.yaml')).params
subnetworks = yaml(content: inspec.profile.file('subnetwork.yaml')).params

control 'network' do
  networks.each do |nw|
    network_name = nw["name"] + "st"
    describe google_compute_network(project: gcp_project_id, name: network_name) do
      it {should exist}
      its ('auto_create_subnetworks'){ should be nw["auto_create_subnetworks"]}
    end
  end
  subnetworks.each do |subnet|
    describe google_compute_subnetwork(project: gcp_project_id, region: subnet["region"], name: subnet["name"]) do
      it {should exist}
      its('ip_cidr_range') { should eq subnet["cidr"]}
      its('log_config.enable'){ should be subnet["log"]}
    end
  end
end
