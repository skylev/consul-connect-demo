provider "google" {
  credentials = "${file("/Users/lev/.gcp/skywiz-meetup.json")}"
  project     = "skywiz-sandbox"
  region      = "us-central1"
}
