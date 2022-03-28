# Manual Running vagrant to create base Image

## To Run this separately from rest of project:
1. install vagrant 
    `brew install vagrant`
2. install plugin run:
`vagrant plugin install vagrant-google`
3. add variables and keys
4. start building machine
`vagrant up`

* if not done already, add an ssh key to your project's Metadata area. The vagrant-google provider will connect to the launched instance using gcp auth.

edit the Vagrantfile:

- set the path to a gcp service account by running in terraform folder `terraform output -raw key > ../kali.json` keyfile (e.g., kali.json as in the root dir of this repo). This will give the plugin permissions to launch instances in your project.
- Put the ssh username (default: vagrant) and SSH key filename/path into the Vagrantfile. The plugin will connect to the launched instance using these credentials.

- If the vagrant provision step is asking for a password, then something may be wrong with your keyfile -- try ssh'ing manually

```
vagrant ssh-config > ssh.config
ssh -F ssh.config default
```

- set the path to your ssh private keyfile to your gcp project. Don't put it in this directory, because if you do, it will be rsync'ed to the guest (to directory /vagrant)! #override.ssh.private_key_path


## Troubleshooting 
1. debugging
` vagrant up --debug `

2. debugging permissions of service account , You should be able to verify whether it's vagrant or something with your service account by making a direct call to the api like so:
```
$ gcloud auth activate-service-account --key-file=/full/path/to/your/key.json
$ alias gcurl='curl -H "Authorization: Bearer $(gcloud auth print-access-token)"'
$ gcurl https://compute.googleapis.com/compute/v1/projects/<your projecy>/zones/us-east1-c/diskTypes/pd-standard
```

If this image is to become a base image for others to launch, then step down the disk space and relaunch before creating the image. resizefs should (hopefully) automatically run on the image as it launches. Then create your image.

Then, run vagrant up!

# To push an image from above 
(if you run Packer, it will take care of this step)

1. Shut down the instance.

`vagrant halt`

2. Use the GCP console to create a new image from the instance backing disk.

3. Get the "disk" name from the Disks console tab. It defaults to be the same name as the image it backed. Also get the disk's "zone.""

4. run the following gcloud command from a console "cloud shell."

```
gcloud compute images create <new-image-name> \
    --source-disk <source-disk-name> \
    --source-disk-zone <source-disk-zone> \
    --family <family-name>
```
For example:
```
gcloud compute images create kali-v3-0-0 \
    --source-disk kali-v3 \
    --source-disk-zone us-central1-f \
    --family security-assignments-kali
https://cloud.google.com/compute/docs/images/image-families-best-practices
```


## Extra VMs
De-ICE VulnHub
To get De-ICE level 1 onto Kali:

Create a libirt virtual network with the following config:
```
  <network connections="1">
    <name>De-ICE</name>
    <uuid>c8b50fe2-876b-439a-9f6c-97d78a5a5dad</uuid>
    <forward mode="nat">
      <nat>
        <port start="1024" end="65535"/>
      </nat>
    </forward>
    <bridge name="virbr3" stp="on" delay="0"/>
    <mac address="52:54:00:2a:33:af"/>
    <domain name="De-ICE"/>
    <ip address="192.168.1.1" netmask="255.255.255.0">
    </ip>
  </network>
```
Download the ISO:
`wget http://hackingdojo.com/downloads/iso/De-ICE_S1.100.iso`

Create a new virtual machine in kali. We're only going to use it to boot off of the ISO, so doesn't need storage.

set to use ISO. Add storage pool and point to De-ICE_S1.100.iso
Generic Linux
Default cpu and memory
Uncheck "Enable storage"
Name it something nice
Network selection > select your De-ICE network.
Finish
You may need to mount the ISO again, after the first boot.

Does not respond to ping (icmp). nmap -O 192.168.1.100 to ensure online.