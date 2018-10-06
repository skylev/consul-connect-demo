resource "google_compute_instance" "web" {
  count = 3
  name         = "web-server-${count.index+1}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["ssh","consul","http-server"]

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
consul agent -config-dir=/etc/consul.d/ -retry-join "provider=gce project_name=skywiz-sandbox tag_value=consul-server zone_pattern=us-central.*" --data-dir /var/lib/consul/  -client 0.0.0.0  &
apt-get install -y nginx
echo "web-server-${count.index+1} is up"  > /var/www/html/index.html
SCRIPT
   }


  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
