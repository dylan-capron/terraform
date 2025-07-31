# variables.tf

variable "vmrest_host" {
  description = "vmrest serteur"
  type        = string
  default     = "127.0.0.1" 
}

variable "vmrest_port" {
  description = "port accés"
  type        = number
  default     = 8697 
}

variable "vmrest_user" {
  description = "utilisateur vmrest"
  type        = string
}

variable "vmrest_password" {
  description = "mdp vmrest"
  type        = string
  sensitive   = true # ne pas apparaitre dans les logs/debug
}

variable "template_vm_id" {
  description = "ID VM a cloner"
  type        = string
}

variable "new_vm_name" {
  description = "nom VM clonée."
  type        = string
}

variable "vm_clone_path" {
  description = "chemin du vmx vm clonée"
  type        = string
}
