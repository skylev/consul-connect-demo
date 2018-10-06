resource "google_compute_instance" "server" {
  count = 3
  name         = "consul-server-${count.index+1}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["ssh", "consul-server","consul"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20180912"
    }
  }


  network_interface {
    network = "default"

    access_config {
    }
  }

   metadata {
        startup-script = <<SCRIPT
wget https://releases.hashicorp.com/consul/1.2.3/consul_1.2.3_linux_amd64.zip
apt-get install -y unzip
unzip consul_1.2.3_linux_amd64.zip
cp ./consul /usr/sbin
mkdir /var/lib/consul/
mkdir /etc/consul.d/
cd /etc/consul.d && wget https://raw.githubusercontent.com/skylev/consul-connect-demo/master/consul1/consul-config.json
consul agent -config-dir=/etc/consul.d/
SCRIPT
   }


  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
