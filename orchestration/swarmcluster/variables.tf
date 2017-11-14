variable "project" {
  default = "dockercertstudy"
}

variable "region" {
  default = "us-east1"
}

variable "is_preemptible" {
  default = true
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "backup" {
  default = false
}
