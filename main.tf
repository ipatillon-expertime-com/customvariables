
// Load global configuration (naming, ...)
module "global" {
  source = "./modules/global"
}

output "naming" {
    value = module.global.naming
}
