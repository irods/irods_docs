# APPENDIX for Chapter 1

## CMAKE

[a Good CMAKE introduction](https://cliutils.gitlab.io/modern-cmake/chapters/basics.html)


## Virtual Machine options
  - HyperV or Docker in Windows 10
  - PARALLELS in MacOS
  - VIRTUALBOX (Windows or Linux)
  - libvirt = most flexible
    * user in group libvirt (Ub>=18) or libvirtd (Ub<=16)
    * virt-manager = GUI
    * QEMU-KVM = technology
    * vagrant = command line, high level VM management tool

---

### libvirt, virt-manager and QEMU-KVM

[Setup](https://help.ubuntu.com/community/KVM/Installation)

### VAGRANT

[Setup](https://computingforgeeks.com/using-vagrant-with-libvirt-on-linux/)

Example
```
mkdir ~/boxes/c7 -p
cd ~/boxes/c7
vagrant init centos/7
mkdir share
```
sample Vagrantfile after customizations (file share with host ; # CPU's and host mem

```
Vagrant.configure("2") do |config|

  ##### DEFINE VM #####
  config.vm.define "cent-01" do |config|
  config.vm.hostname = "cent-01"
  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.122.9"
  config.vm.synced_folder "share/", "/share"
  config.vm.provider :libvirt do |v|
    v.memory = 16384
    v.cpus = 16
    end
  end
end

---

`vagrant global-status` lists configured VMs and their SHAs

cd into the Vagrantfile directory to use these commands without a SHA

```
vagrant up      provision VM if necessary, then run
                (creates a secure keypair for ssh into the VM)
vagrant ssh     get a secure shell into the VM
vagrant halt    halts the VM
vagrant reload  reboot the VM
vagrant resync
---
<A id="rr_gdb"> </A>
RR and GDB in a libvirt  VM
        `/proc/sys/kernel/yama/ptrace_scope` no higher than 0
        `/proc/sys/kernel/perf_event_paranoid` no higher than  1
Therefore:
   - Change those settings on the host, via `sysctl`
   - Allow them to filter into the VM
     locate  <domain> | grep '\.xml$'
     in the XML change cpu tag to:
     ```
     <cpu mode="host-passthrough" ... >
     ```
     Then on the host machine: sudo systemctl reload libvirtd
```
