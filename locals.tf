locals {
  prefix = "${var.project_name}-${var.env}"

  tags = {
    Project            = var.project_name
    Environment        = var.env
    Owner              = var.owner
    CostCenter         = var.cost_center
    ManagedBy          = "Terraform"
    DataClassification = "Non-PCI (Lab)"
  }
}
