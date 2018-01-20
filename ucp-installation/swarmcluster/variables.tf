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
  default = "n1-standard-2"
}

variable "backup" {
  default = false
}

variable "master_count" {
  default = 3
}
