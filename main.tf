# main.tf

terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

# --- Resource to Clone VM ---
# null_resource pour  commandes (curl)
# via 'local-exec' provisioner
resource "null_resource" "clone_vm" {

  triggers = {
    template_vm_id   = var.template_vm_id
    new_vm_name      = var.new_vm_name
    vm_clone_path    = var.vm_clone_path 
  }

  provisioner "local-exec" {
    # Environment variables
    environment = {
      TF_TEMPLATE_VM_ID  = var.template_vm_id
      TF_NEW_VM_NAME     = var.new_vm_name
      TF_VM_CLONE_PATH   = var.vm_clone_path
      TF_VMREST_HOST     = var.vmrest_host
      TF_VMREST_PORT     = var.vmrest_port
      TF_VMREST_USER     = var.vmrest_user
      TF_VMREST_PASSWORD = var.vmrest_password
    }

#    command = trimspace(<<EOT
#      bash -c "urlencode() { python3 -c 'import urllib.parse, sys; print(urllib.parse.quote_plus(sys.stdin.read().rstrip(\"\\n\")))' <<< \"\$1\"; }; echo \"DEBUG: Attempting to clone VM...\"; echo \"DEBUG: Template ID (parentId): \$TF_TEMPLATE_VM_ID\"; echo \"DEBUG: New VM Name: \$TF_NEW_VM_NAME\"; echo \"DEBUG: Target URL: http://\$TF_VMREST_HOST:\$TF_VMREST_PORT/api/vms\"; echo \"DEBUG: Data Payload: { \\\"name\\\": \\\"\$TF_NEW_VM_NAME\\\", \\\"parentId\\\": \\\"\$TF_TEMPLATE_VM_ID\\\" }\"; CLONE_RESPONSE=\$(curl -v -X POST -H \"Content-Type: application/vnd.vmware.vmw.rest-v1+json\" -u \"\$TF_VMREST_USER:\$TF_VMREST_PASSWORD\" \"http://\$TF_VMREST_HOST:\$TF_VMREST_PORT/api/vms\" -d '{\"name\":\"'\$TF_NEW_VM_NAME'\", \"parentId\":\"'\$TF_TEMPLATE_VM_ID'\"}' 2>&1); echo \"DEBUG: Curl command exited with status \$?.\"; echo \"DEBUG: Full CURL Response/Errors:\"; echo \"\$CLONE_RESPONSE\"; echo \"DEBUG: End of CURL Response.\"; JSON_PAYLOAD=\$(echo \"\$CLONE_RESPONSE\" | awk '/^[{[]/ { p=1 } p; /^[}\\]]/ { p=0 }'); if echo \"\$CLONE_RESPONSE\" | grep -q \"^< HTTP/1.[01] 20[01]\"; then NEW_VM_ID=\$(echo \"\$JSON_PAYLOAD\" | jq -r '.id' 2>/dev/null); if [ -z \"\$NEW_VM_ID\" ] || [ \"\$(echo \"\$JSON_PAYLOAD\" | jq -r '.Message' 2>/dev/null)\" != \"null\" ]; then echo \"Error: vmrest clone API returned an error or ID missing despite HTTP success.\"; echo \"Full vmrest API JSON Response: \$JSON_PAYLOAD\"; exit 1; fi; else echo \"Error: HTTP request did not return 2xx success status.\"; echo \"Full CURL Response/Errors: \\n\$CLONE_RESPONSE\"; exit 1; fi; echo \"Cloned VM ID: \$NEW_VM_ID\"; echo \"\$NEW_VM_ID\" > \"/tmp/terraform_cloned_vm_id_\$TF_NEW_VM_NAME.txt\";"
#    EOT
#    )

    command = trimspace(<<EOT
      bash -c "urlencode() { python3 -c 'import urllib.parse, sys; print(urllib.parse.quote_plus(sys.stdin.read().rstrip(\"\\n\")))' <<< \"\$1\"; }; echo \"DEBUG: Attempting to clone VM...\"; echo \"DEBUG: Template ID (parentId): \$TF_TEMPLATE_VM_ID\"; echo \"DEBUG: New VM Name: \$TF_NEW_VM_NAME\"; echo \"DEBUG: Target URL: http://\$TF_VMREST_HOST:\$TF_VMREST_PORT/api/vms\"; echo \"DEBUG: Data Payload: { \\\"name\\\": \\\"\$TF_NEW_VM_NAME\\\", \\\"parentId\\\": \\\"\$TF_TEMPLATE_VM_ID\\\" }\"; CLONE_RESPONSE=\$(curl -v -X POST -H \"Content-Type: application/vnd.vmware.vmw.rest-v1+json\" -u \"\$TF_VMREST_USER:\$TF_VMREST_PASSWORD\" \"http://\$TF_VMREST_HOST:\$TF_VMREST_PORT/api/vms\" -d '{\"name\":\"'\$TF_NEW_VM_NAME'\", \"parentId\":\"'\$TF_TEMPLATE_VM_ID'\"}' 2>&1); echo \"DEBUG: Curl command exited with status \$?.\"; echo \"DEBUG: Full CURL Response/Errors:\"; echo \"\$CLONE_RESPONSE\"; echo \"DEBUG: End of CURL Response.\"; JSON_PAYLOAD=\$(echo \"\$CLONE_RESPONSE\" | jq -c '.' | tail -1); if echo \"\$CLONE_RESPONSE\" | grep -q \"^< HTTP/1.[01] 20[01]\"; then NEW_VM_ID=\$(echo \"\$JSON_PAYLOAD\" | jq -r '.id' 2>/dev/null); if [ -z \"\$NEW_VM_ID\" ] || [ \"\$(echo \"\$JSON_PAYLOAD\" | jq -r '.Message' 2>/dev/null)\" != \"null\" ]; then echo \"Error: vmrest clone API returned an error or ID missing despite HTTP success.\"; echo \"Full vmrest API JSON Response: \$JSON_PAYLOAD\"; exit 1; fi; else echo \"Error: HTTP request did not return 2xx success status.\"; echo \"Full CURL Response/Errors: \\n\$CLONE_RESPONSE\"; exit 1; fi; echo \"Cloned VM ID: \$NEW_VM_ID\"; echo \"\$NEW_VM_ID\" > \"/tmp/terraform_cloned_vm_id_\$TF_NEW_VM_NAME.txt\";"
    EOT
    )

    # on_failure = continue pour debug
    on_failure = continue
  }
}
