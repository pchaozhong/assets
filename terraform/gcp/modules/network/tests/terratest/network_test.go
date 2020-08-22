package terratest

import (
	"testing"

    "github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestNetwork(t *testing.T) {
	t.Parallel()


    projectId := gcp.GetGoogleProjectIDFromEnvVar(t)

	terraformOptions := &terraform.Options{
		TerraformDir: ".",

        EnvVars: map[string]string{
			"GOOGLE_PROJECT": projectId,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

    testNetworkName := terraform.Output(t, terraformOptions, "test_nw_name")
    testSubnetCidr := terraform.Output(t, terraformOptions, "test_sbnw_cidr")

    assert.Equal(t, "test", testNetworkName)
    assert.Equal(t, "192.168.0.0/29", testSubnetCidr)
}
