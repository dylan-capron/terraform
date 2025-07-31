# outputs.tf

output "cloned_vm_name" {
  description = "non vm clonée"
  value       = var.new_vm_name
}

output "cloned_vm_path" {
  description = "chemin VM clonée"
  value       = var.vm_clone_path
}

output "actual_cloned_vm_id" {
  description = "ID de la VM clonée."
  value       = fileexists("/tmp/terraform_cloned_vm_id_${var.new_vm_name}.txt") ? trimspace(file("/tmp/terraform_cloned_vm_id_${var.new_vm_name}.txt")) : "ID not found or clone failed"
  depends_on = [null_resource.clone_vm] # Ensure this output is only evaluated after clone_vm
}
