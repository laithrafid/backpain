## Requirements:
1. install packer
2. install packer plugins
3. run terraform
4. run first part of vagrant up
5. run packer build

## how to run:
* copy variables file 
`cp testing.pkrvars.hcl.template testing.pkrvars.hcl`
* fill variables file as documentd by comments
* run below
`packer build -var-file=testing.pkrvars.hcl . `