module "kms" {
  source = "../modules/kms"

  kms_conf = [
    {
      kms_enable    = false
      crypto_enable = false

      key_ring_conf = {
        name     = "test"
        location = "global"
      }

      crypto_key = [
        {
          name            = "test"
          prevent_destroy = false
        }
      ]
    }
  ]
}
