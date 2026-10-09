package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestNetworking(t *testing.T) {
	t.Parallel()
	opts := &terraform.Options{
		TerraformDir: "../../terraform/modules/networking",
		Vars: map[string]interface{}{
			"name":     "test",
			"vpc_cidr": "10.99.0.0/16",
			"azs":      []string{"us-east-1a", "us-east-1b"},
		},
	}
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	vpcID := terraform.Output(t, opts, "vpc_id")
	assert.NotEmpty(t, vpcID)
	subnets := terraform.OutputList(t, opts, "private_subnet_ids")
	assert.Len(t, subnets, 2)
}
