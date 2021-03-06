provider "kubernetes" {
  version                = "= 1.5.0"
  load_config_file       = false
  host                   = "https://${var.gke_cluster["master_private_endpoint"]}"
  token                  = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(module.gke_cluster.cluster_ca_certificate)}"
}

module "helm_provider_helper" {
  source                = "git@github.com:thesis/infrastructure.git//terraform/modules/helm_tiller_helper"
  tiller_namespace_name = "${var.tiller_namespace_name}"
}

provider "helm" {
  version = "= 0.7.0"

  kubernetes {
    host                   = "https://${var.gke_cluster["master_private_endpoint"]}"
    token                  = "${data.google_client_config.default.access_token}"
    cluster_ca_certificate = "${base64decode(module.gke_cluster.cluster_ca_certificate)}"
  }

  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"
  service_account = "${module.helm_provider_helper.tiller_service_account}"
  override        = ["spec.template.spec.automountserviceaccounttoken=true"]
  namespace       = "${module.helm_provider_helper.tiller_namespace}"
  install_tiller  = true
}

# create gke cluster
module "gke_cluster" {
  source           = "git@github.com:thesis/infrastructure.git//terraform/modules/gcp_gke"
  project          = "${module.project.project_id}"
  region           = "${var.region_data["region"]}"
  vpc_network_name = "${module.vpc.vpc_network_name}"

  gke_subnet {
    name                             = "${local.gke_subnet_name}"
    primary_ip_cidr_range            = "${var.gke_subnet["primary_ip_cidr_range"]}"
    services_secondary_range_name    = "${var.gke_subnet["services_secondary_range_name"]}"
    services_secondary_ip_cidr_range = "${var.gke_subnet["services_secondary_ip_cidr_range"]}"
    cluster_secondary_range_name     = "${var.gke_subnet["cluster_secondary_range_name"]}"
    cluster_secondary_ip_cidr_range  = "${var.gke_subnet["cluster_secondary_ip_cidr_range"]}"
  }

  gke_cluster {
    name                                = "${var.gke_cluster["name"]}"
    private_cluster                     = "${var.gke_cluster["private_cluster"]}"
    master_ipv4_cidr_block              = "${var.gke_cluster["master_ipv4_cidr_block"]}"
    daily_maintenance_window_start_time = "${var.gke_cluster["daily_maintenance_window_start_time"]}"
    network_policy_enabled              = "${var.gke_cluster["network_policy_enabled"]}"
    network_policy_provider             = "${var.gke_cluster["network_policy_provider"]}"
    logging_service                     = "${var.gke_cluster["logging_service"]}"
    monitoring_service                  = "${var.gke_cluster["monitoring_service"]}"
  }

  gke_node_pool {
    name         = "${var.gke_node_pool["name"]}"
    node_count   = "${var.gke_node_pool["node_count"]}"
    machine_type = "${var.gke_node_pool["machine_type"]}"
    disk_type    = "${var.gke_node_pool["disk_type"]}"
    disk_size_gb = "${var.gke_node_pool["disk_size_gb"]}"
    oauth_scopes = "${var.gke_node_pool["oauth_scopes"]}"
    auto_repair  = "${var.gke_node_pool["auto_repair"]}"
    auto_upgrade = "${var.gke_node_pool["auto_upgrade"]}"
    tags         = "${module.nat_gateway_zone_a.routing_tag_regional}"
  }

  labels = "${local.labels}"
}
