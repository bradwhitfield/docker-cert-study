provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "manager" {
  name         = "manager1"
  machine_type = "${var.machine_type}"
  zone         = "us-east1-b"

  tags = ["manager1", "swarm"]

  boot_disk {
    initialize_params {
      image = "coreos-stable-1520-8-0-v20171026"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  scheduling {
    preemptible = "${var.is_preemptible}"
    automatic_restart = false
  }
}

resource "google_compute_instance" "node1" {
  name         = "node1"
  machine_type = "${var.machine_type}"
  zone         = "us-east1-b"

  tags = ["node", "swarm"]

  boot_disk {
    initialize_params {
      image = "coreos-stable-1520-8-0-v20171026"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  scheduling {
    preemptible = "${var.is_preemptible}"
    automatic_restart = false
  }
}

resource "google_compute_instance" "node2" {
  name         = "node2"
  machine_type = "${var.machine_type}"
  zone         = "us-east1-b"

  tags = ["node", "swarm"]

  boot_disk {
    initialize_params {
      image = "coreos-stable-1520-8-0-v20171026"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  scheduling {
    preemptible = "${var.is_preemptible}"
    automatic_restart = false
  }
}
