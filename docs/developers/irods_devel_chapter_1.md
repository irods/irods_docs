# Training Links

## Start Here

[Beginner iRODS training](https://github.com/irods/irods_training/tree/ugm2019/beginner)


The training examples can be run on an Intel PC or virtual machine.
   * bare-metal PC running a Linux server or desktop
      - Ubuntu 16.04 or 18.04
      - (Alternatively) CentOS or RHEL 7
   * A Ubuntu 16/18.04 VM allocated from Amazon AWS
   * Locally provisioned VM running Ubuntu
      - Windows 10 / HyperV
      - MacOS / Parallels
      - Any Linux or Windows machine equipped with virtualbox
      - libvirtd via the `virt-manager` GUI or the vagrant commands
   * Other (Linux) VM
      - [QEMU/KVM](https://help.ubuntu.com/community/KVM/Installation)
      * [Vagrant](https://computingforgeeks.com/using-vagrant-with-libvirt-on-linux/)


## Advanced iRODS Training


Exposition provided in these [slides](https://slides.com/irods); scroll to UGM 2019

Working materials provided [here](https://github.com/irods/irods_training/tree/ugm2019/advanced)
   * some examples (microservices / API) compile only with <=4.2.7 at this time
   * under eg Ubuntu we give the version hint to apt in this way:
   ```
   $ sudo apt install irods-server=4.2.7 irods-database-plugin-postgres=4.2.7 \
                      irods-runtime=4.2.7 irods-icommands=4.2.7 \
                      irods-dev=4.2.7
   ```
   followed by the running of `/var/lib/irods/scripts/irods_setup.py` as explained before in 
   beginning training.
   *

# Upgrades and Building from Source

For the remainder of the documentation and training contained here, we'll be using docker 
containers for the most part. We'll also base our approach on Ubuntu, one of the more user-
friendly Linux distributions.

As a basic point of order, we can very expediently set up a new iRODS install by starting with
a generic Ubuntu image.

If Docker Engine is not already installed on your machine, do so now.

Start a ubuntu container:
   ```
   $ docker run -it ubuntu:18.04
   ```

Inside this container, you can use the following commands to expedite the installation 
and configuration of an older version of irods, 4.2.6 . Never fear, we'll be upgrading it soon.

There's no magic here; the install.sh script merely installs prerequisites for and installs
(either from internet via APT or local build directories via DPKG) the desired iRODS version.

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
