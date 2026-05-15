variable "project_name" {
  type        = string
  default     = "webrtc-ebpf"
  description = "Project name prefix for all resources"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (dev/staging/prod)"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-webrtc-ebpf-dev"
  description = "Resource group name"
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "VNet CIDR"
}

variable "aks_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "AKS subnet CIDR"
}

variable "system_node_count" {
  type        = number
  default     = 1
  description = "System pool node count"
}

variable "system_node_vm_size" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "System pool VM size"
}

variable "ebpf_node_count" {
  type        = number
  default     = 2
  description = "eBPF node pool count"
}

variable "ebpf_node_vm_size" {
  type        = string
  default     = "Standard_D4s_v3"
  description = "eBPF pool VM size (must support accelerated networking)"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.28"
  description = "AKS Kubernetes version"
}

variable "acr_sku" {
  type        = string
  default     = "Basic"
  description = "ACR tier"
}

variable "log_retention_days" {
  type        = number
  default     = 30
  description = "Log Analytics retention days"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for node access"
}

variable "tags" {
  type = map(string)
  default = {
    project     = "webrtc-ebpf"
    environment = "dev"
    managed_by  = "terraform"
    team        = "infra"
  }
}
