# Training Links

iRODS Training
---

Training exercises can be run on a suitable VM 

   * bare metal PC running a Linux server or desktop
      - Ubuntu 16.04 or 18.04
      - CentOS (RHEL) 7
   * Amazon AWS
   * Local VM
      - Windows 10 / HyperV 
      - MacOS / Parallels
      - (any) Linux running virtualbox
      - libvirtd via `virt-manager` GUI or the vagrant commands
   * Linux VMs
   - QEMU/KVM - https://help.ubuntu.com/community/KVM/Installation
   - Vagrant https://computingforgeeks.com/using-vagrant-with-libvirt-on-linux/


Beginner iRODS training - PDF
---
https://github.com/irods/irods_training/tree/ugm2019/beginner 
 

Advanced iRODS Training
---

Exposition provided in these [slides](https://slides.com/irods); scroll to UGM 2019

Working materials provided [here](https://github.com/irods/irods_training/tree/ugm2019/advanced) 
   * some examples (microservices / API) compile only with <=4.2.7 at this time

## Build env for advanced part of irods_trainig can be set up easily in a Ubuntu  container:

Using docker , start a ubuntu container:
   ```
   $ docker run -it ubuntu:18.04
   ```

Inside the container, type the following:
   ```
   # apt-get update 
   # apt-get install sudo git vim nano  # <-- your favorite TUI mode editor here

   # git clone https://github.com/d-w-moore/ubuntu_irods_installer

   # /ubuntu_irods_installer/install.sh --w='config-essentials create-db add-needed-runtime' 0
   # /ubuntu_irods_installer/install.sh -r --i=4.2.6 4 5  # --> install & configure iRODS

   # su - irods
   $ ils
   /tempZone/home/rods
   ```

Now:
   - Exit the shell we're running as `irods` (the service account user).
   - Optionally create a different login account so that wer're not working as root user...
As the new user (in forthcoming example sessions, will be given the generic name "ubuntu")
   - Run iinit
      * Enter as answer: hostname , 1247 , rods , tempZone, `rods` (default admin password).


**(Insert optional exercise here to build iRODS from branch 4-2-stable .
   And use ubuntu_irods_installer to de-install , re-install)**


## Build sample API plugin

The commands above install enough of the build environment (CMake, clang and runtime, and
Boost and various other dependencies of iRODS) that we can build microservices and other 
plugins.

For an example, let's use the environment we've set up in the container compile the API example
plugin from the advanced training directory:

   - As the `ubuntu` user, or any sudo enabled user, do this:
     ```
     $ git clone http://github.com/irods/irods_training ~/irods_training
     $ cd ~/irods_training/advanced/irods_api_example
     [ make sure CMakeLists.txt references 4.2.6 near the top  of the file, as that is the iRODS
       server version we installed ]
     $ mkdir obj ; cd obj ; /opt/irods-externals/cmake3.11.4-0/bin/cmake .. ; make
     $ sudo install lib*.so /usr/lib/irods/plugins/api
     $ export LD_LIBRARY_PATH=/opt/irods-externals/clang-runtime3.8-0/lib
     $ ./iapi_example
     
     ```
   - make sure ~/irods_training




TMUX
   - tmux a - attach to existing session
   - tmux   - create new session
   - ctrl-b (") horizontally split
   - ctrl-b (%) vertically split
VAGRANT / libvirtd
   - virsh
   - cd into empty directory;
     ``` vagrant init centos/7
   - vagrant init centos/7
systemctl reload 
