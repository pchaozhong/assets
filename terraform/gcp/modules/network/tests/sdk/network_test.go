package sdk

import (
    "testing"
    "fmt"
    "os"

    network "../../../../../../iaas/sdk/gcp/golang/testingtool/network"
)

func TestVPCNetwork(t *testing.T){
    actual := network.ContainVPCNetwork("test")
    expected := true
    if actual != expected {
        t.Errorf("got: %v\nwant: %v", actual, expected)
    }
}

func TestGetCidr(t *testing.T){
    actual, err := network.GetCidr("test", "asia-northeast1")
    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
    expected := "192.168.0.0/29"

    if actual != expected {
        t.Errorf("got: %v\nwant: %v", actual, expected)
    }
}