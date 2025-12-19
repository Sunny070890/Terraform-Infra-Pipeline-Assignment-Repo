
variable "rg" {
  type = map(object({
    rg_name     = string
    rg_location = string
    tags        = optional(map(string))
  }))
}
