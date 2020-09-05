package gce_stop

import (
	"context"
	"fmt"
	"google.golang.org/api/compute/v1"
	"os"
	"strings"
)

type PubSubMessage struct {
	Data []byte `json:"data"`
}

func GetZones(cps *compute.Service) ([]string, error) {
	var zones []string

	zs := compute.NewZonesService(cps)
	zoneList, err := zs.List(os.Getenv("GCP_PROJECT")).Do()

	if err != nil {
		return zones, err
	}

	for _, zone := range zoneList.Items {
		zones = append(zones, zone.Name)
	}

	return zones, nil
}

func GetInstances(cs *compute.InstancesService, zones []string) ([]*compute.Instance, error) {
	var gces []*compute.Instance

	for _, z := range zones {
		instances, err := cs.List(os.Getenv("GCP_PROJECT"), z).Do()
		if err != nil {
			return gces, err
		}

		for _, i := range instances.Items {
			gces = append(gces, i)
		}
	}
	return gces, nil
}

func StopGCEInstances(sa *compute.InstancesService, gce *compute.Instance) error {
	metadatas := *gce.Metadata

	for _, m := range metadatas.Items {
		if m.Key == "poweroff-schedule" {
			err := StopScheduledGCEInstance(sa, gce, m)
			if err != nil {
				return err
			}
		}
	}

	return nil
}

func StopScheduledGCEInstance(sa *compute.InstancesService, gce *compute.Instance, metadata *compute.MetadataItems) error {
	tmps := strings.Split(gce.Zone, "/")
	zone := tmps[len(tmps)-1]

	if *metadata.Value == "on" && gce.Status == "RUNNING" {
		_, err := sa.Stop(os.Getenv("GCP_PROJECT"), zone, gce.Name).Do()
		return err
	}
	return nil
}

func StopGCEInstancesDaily(ctx context.Context, m PubSubMessage) error {
	cps, err := compute.NewService(ctx)
	if err != nil {
		return err
	}
	sa := compute.NewInstancesService(cps)

	zones, err := GetZones(cps)
	if err != nil {
		return err
	}

	gces, err := GetInstances(sa, zones)
	if err != nil {
		return err
	}

	for _, gce := range gces {
		err = StopGCEInstances(sa, gce)
		if err != nil {
			return err
		}
		fmt.Printf("STOP %s VM", gce.Name)
	}

	return nil
}
