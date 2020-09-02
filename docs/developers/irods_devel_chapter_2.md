# Chapter 2 - debugging


[Beginner iRODS training](https://github.com/irods/irods_training/blob/ugm2019/beginner/irods_beginner_training_2019.pdf)

## Advanced iRODS Training

Exposition provided in these [slides](https://slides.com/irods); scroll to UGM 2019

Working materials provided [here](https://github.com/irods/irods_training/tree/ugm2019/advanced)

# Making a containerized development environment

For the remainder of the documentation and training contained here, we'll be using docker 
containers for the most part. We'll also base our approach on Ubuntu, one of the more user-
friendly Linux distributions.

As a basic point of order, we can very expediently set up a new iRODS install by starting with
a generic Ubuntu image.

If Docker Engine is not already installed on your machine, do so now.

We'll start out with a skeletal setup where the necessary iRODS packages for running a single node
server and compiling new code against it, are already loaded.

Using the [Dockerfile](./Dockerfile) included here:

  - Build the container
    ```
    docker build -f Dockerfile -t ub18-irods-dev .
    ```
  - Run the container:
    ```
    docker run -i -t ub18-irods-dev 
    ```

Inside the container, at the bash root prompt (#), type these commands:
  - Start the PostgreSQL server
    ```
    service postgresql start
    ```
  - Configure and run the iRODS server:
    ```
    python /var/lib/irods/scripts/setup_irods.py </var/lib/irods/packaging/localhost_setup_postgres.input
    ```
    This command will verify the server is running; it should print the service account's home collection:
    ```
    su - irods -c 'ils'
    ```
Now
  - Exit the shell we're running as `irods` (the service account user).
    Create a different login account so that we're not always working as the root user...
    But give that account password-less sudo  for the admin tasks that will be needed.
    * eg 
    ```
    # useradd -m -s /bin/bash ubuntu
    # echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers
    ```
  - `su` to the new user `ubuntu` and run the `iinit` command to set up a client environment:
    * Enter as answers: the container's hostname , `1247` , `rods` , `tempZone`, `rods` (default admin password).


**(Insert optional exercise here to build iRODS from branch 4-2-stable .
   And use ubuntu_irods_installer to de-install , re-install)**

   
**(Another exercise here to demonstrate running part of the python test suite)**


## Build an example API plugin

Let's use the environment within the container to compile an the training API example:

   - As the `ubuntu` user, do the following:
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

