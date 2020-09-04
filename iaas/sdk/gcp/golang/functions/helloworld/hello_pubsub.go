package helloworld

import (
    "context"
    "log"
    "encoding/json"
)
//Pub/Subからのメッセージは"data"にバイト列で入るらしい。構造体のバインドをもっと上手に
//やる方法を模索中
type PubSubMessage struct {
    Data []byte `json:"data"`
}
type Info struct {
    Name  string `json:"name"`
    Place string `json:"place"`
}
// Pub/Subからメッセージを受診したらこの関数が起動する
func HelloFromPubSub(ctx context.Context, m PubSubMessage) error {
    var i Info

    err := json.Unmarshal(m.Data, &i)

    if err != nil {
        log.Printf("Error:%T message: %v", err, err)
        return nil
    }

    log.Printf("こんにちは、%sさん！%sへCloud Pub/SubからFunctions経由で愛をこめて。", i.Name, i.Place)
    return nil
}
