package main

import (
	"context"
	"fmt"
	"google.golang.org/api/compute/v1"
	"os"
)

func contains(s []string,e string) bool{
    for _, content := range s {
        if content == e {
            return true
        }
    }
    return false
}

func main() {
    ctx := context.Background()
    cps, err := compute.NewService(ctx)
    // isa := compute.NewInstancesService(cps)
    nws := compute.NewNetworksService(cps)
    if err != nil {
        fmt.Println(err)
    }
    // zones, err := GetZones(cps)
    list, err := nws.List(os.Getenv("GCP_PROJECT")).Do()
    if err != nil {
        fmt.Println(err)
    }
    nList := list.Items
    var networkName []string

    for _, n := range nList {
        networkName = append(networkName, n.Name)
    }
    fmt.Println(networkName)
    if contains(networkName, "default") {
        fmt.Println("contains")
    } else {
        fmt.Println("Not contains")
    }
}
