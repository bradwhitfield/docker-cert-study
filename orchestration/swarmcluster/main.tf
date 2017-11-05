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
    preemptible       = "${var.is_preemptible}"
    automatic_restart = false
  }

  depends_on = ["google_compute_instance.node1", "google_compute_instance.node2"]

  // Pretty sure this doesn't work because CoreOS doesn't want you to run bash scripts at startup
  // I probably won't fix this since I need to log into the manager anyways
  // Instead run "curl curl 169.254.169.254/0.1/meta-data/attributes/startup-script -o startup.sh && chmod +x startup.sh && ./startup.sh"
  metadata_startup_script = "${data.template_file.manager_init.rendered}"
}

data "template_file" "manager_init" {
  template = "${file("files/manager.tpl")}"

  vars {
    node1_ip = "${google_compute_instance.node1.network_interface.0.address}"
    node2_ip = "${google_compute_instance.node2.network_interface.0.address}"
  }

  depends_on = ["google_compute_instance.node1", "google_compute_instance.node2"]
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
    preemptible       = "${var.is_preemptible}"
    automatic_restart = false
  }

  metadata = {
    user-data = "${file("files/node.ign")}"
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
    preemptible       = "${var.is_preemptible}"
    automatic_restart = false
  }

  metadata = {
    user-data = "${file("files/node.ign")}"
  }
}
