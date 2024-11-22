
data "archive_file" "maf_datadog" {
  type        = "zip"
  source_dir  = "${path.module}/../charts/maf-datadog"
  output_path = "/tmp/tf/maf-datadog.zip"
}

data "aws_secretsmanager_secret" "datadog" {
  count = var.datadog_secret_name != null ? 1 : 0

  name = var.datadog_secret_name
}

data "aws_secretsmanager_secret_version" "datadog" {
  count = var.datadog_secret_name != null ? 1 : 0

  secret_id = data.aws_secretsmanager_secret.datadog[0].id
}

resource "helm_release" "maf_datadog" {
  count = var.datadog_secret_name != null ? 1 : 0

  name  = "maf-datadog"
  chart = "${path.module}/../charts/maf-datadog"

  lint = true

  namespace        = "datadog"
  create_namespace = true

  set {
    name  = "hash"
    value = data.archive_file.maf_datadog.output_sha
  }
  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set_sensitive {
    name  = "secretApiKey"
    value = jsondecode(data.aws_secretsmanager_secret_version.datadog[0].secret_string)["api_key"]
  }
  set_sensitive {
    name  = "secretClusterAgentToken"
    value = jsondecode(data.aws_secretsmanager_secret_version.datadog[0].secret_string)["token"]
  }
}