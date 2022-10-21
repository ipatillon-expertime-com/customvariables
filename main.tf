
// Load global configuration (naming, ...)
module "global" {
  source = "./modules/global"
}

output "out1" {
    value = module.global.naming
}
