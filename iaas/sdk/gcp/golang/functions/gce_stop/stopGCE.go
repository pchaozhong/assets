package functions

import (
    "os"
    "context"
    "log"
    // "strings"

    "google.golang.org/api/compute/v1"
)

type PubSubMessage struct {
	Data []byte `json:"data"`
}

func createSv(ctx context.Context) (*compute.Service, error){
    return compute.NewService(ctx)
}

func getInstanceService(ctx context.Context) (*compute.InstancesService, error) {
    sv, err := createSv(ctx)
    return compute.NewInstancesService(sv), err
}

func GetZones(ctx context.Context,m PubSubMessage) (error) {
	var zones []string
    log.Println(string(m.Data))

    sv , err := compute.NewService(ctx)

    if err != nil {
        log.Println("error NewService")
        log.Println(err)
		return err
	}

    log.Println("before new zoneservice")
	zs := compute.NewZonesService(sv)
    log.Println("before getting zone list")
	zoneList, err := zs.List(os.Getenv("GCP_PROJECT")).Do()

	if err != nil {
        log.Println("error zs error")
        log.Println(err)
		return err
	}

	for _, zone := range zoneList.Items {
		zones = append(zones, zone.Name)
	}

    log.Println(zones)
	return nil
}

// func getInstances(ctx context.Context) ([]*compute.Instance, error){
//     var gces []*compute.Instance
//     zones, err := getZones(ctx)

//     if err != nil {
//         return gces, err
//     }

//     isv , err := getInstanceService(ctx)

//     if err != nil {
//         return gces, err
//     }

//     for _,z := range zones {
//         instances, err := isv.List(os.Getenv("GCP_PROJECT"),z).Do()
//         if err != nil {
//             return gces, err
//         }

//         for _,i := range instances.Items{
//             gces = append(gces, i)
//         }
//     }

//     return gces, nil
// }

// func stopGCE(gce *compute.Instance,ctx context.Context) error {
//     t := strings.Split(gce.Zone, "/")
//     zone := t[len(t)-1]
//     isa, err := getInstanceService(ctx)

//     if err != nil {
//         return err
//     }


//     if gce.Status == "RUNNING" {
//         _, err := isa.Stop(os.Getenv("GCP_PROJECT"), zone, gce.Name).Do()
//         return err
//     }

//     return nil
// }

// func StopAllGCEs(ctx context.Context, m PubSubMessage) error {
//     gces, err := getInstances(ctx)
//     if err != nil {
//         return err
//     }
//     for _, g := range(gces) {
//         fmt.Println("stop gce: ", g.Name)
//         err = stopGCE(g, ctx)
//         if err != nil {
//             return err
//         }
//     }

//     fmt.Println("Finish Stopping Task")
//     return nil
// }
