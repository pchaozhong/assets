package terratest

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestNetwork(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	testNetworkName := terraform.Output(t, terraformOptions, "test_network_name")
	testSubnetCidr := terraform.Output(t, terraformOptions, "test_subnet_cidr")

	assert.Equal(t, "test", testNetworkName)
	assert.Equal(t, "192.168.0.0/29", testSubnetCidr)
    assert.Equal(t, "192.168.1.0/29", testSubnetCidr)
}
