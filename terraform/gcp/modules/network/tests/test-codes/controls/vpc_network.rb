title 'network module test'

gcp_project_id = attribute('gcp_project_id')

control 'test' do
  describe google_compute_network(project: gcp_project_id, name: 'test') do
    it {should exist}
    its ('auto_create_subnetworks'){ should be false}
  end
end
