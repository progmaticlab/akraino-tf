#This repo should be moved to https://gerrit.akraino.org/r/admin/repos/nc/tf


Instructions for installing airship+tungstenfabric using the Regional Controller and the TF Blueprint
======================================================================================================

1. The Regional Controller should already be running somewhere (hopefully on a machine or
   VM dedicated for this purpose). See here_ for instructions on how to start the regional
   controller.

   .. _here: https://wiki.akraino.org/display/AK/Starting+the+Regional+Controller
   
2. Clone the *tf* repository using

   ~~~

     #git clone https://gerrit.akraino.org/r/tf.git
     git clone https://github.com/gleb108/akraino-tf.git
   ~~~  

3. Regional Controller goes to the remote node by ssh, so it needs ssh private key.
   It can be provided as http URL. (It's not secure for production, it's only OK for the demo)
   Put ssh private key and script deploy.sh on some web server. 
   Ssh public key must be writen to the .ssh/authorized_keys on remote node.
   Hint: python provisional web server can be used on the localhost. Use python3 -m http.server 
       
4. Edit the file *setup-env.sh*.

   Update all the environment variables  define the ip addresses nodes, web server baseurl, etc
   Define where the Regional Controller is located, as well as the login/password to use
   (the login/password shown here are the built-in values and do not need to be changed
   if you have not changed them on the Regional Controller):

   ~~~

     export RC_HOST=<IP or DNS name of Regional Controller>
     export USER=admin
     export PW=admin123
   ~~~

5. Generate yaml files from templates

   ~~~ 
      source setup-env.sh
      cat objects.yaml.env | envsubst > objects.yaml
      cat TF_blueprint.yaml.env | envsubst > TF_blueprint.yaml  
   ~~~   

6. Clone the *api-server* repository.  This provides the CLI tools used to interact with the
   Regional Controller.  Add the scripts from this repository to your PATH:

   ~~~
     git clone https://gerrit.akraino.org/r/regional_controller/api-server
     export PATH=$PATH:$PWD/api-server/scripts
   ~~~  

7. Load the objects defined in *objects.yaml* into the Regional Controller using:

   ~~~
     rc_loaddata -H $RC_HOST -u $RC_USER -p $RC_PW -A objects.yaml
   ~~~  

8. Load the blueprint into the Regional Controller using:

   ~~~
     rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW blueprint create TF_blueprint.yaml
   ~~~

9. Get the UUIDs of the edgesite and the blueprint from the Regional Controller using:

    ~~~
      rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW blueprint list
      rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW edgesite list
    ~~~  

    These are needed to create the POD.  You will also see the UUID of the Blueprint displayed
    when you create the Blueprint in step 8 (it is at the tail end of the URL that is printed).
    Set and export them as the environment variables ESID and BPID.

    ~~~
      export ESID=<UUID of edgesite in the RC>
      export BPID=<UUID of blueprint in the RC>
    ~~~ 

10. Generate POD.yaml 

   ~~~
      cat POD.yaml.env | envsubst > POD.yaml
   ~~~   

11. Create the POD using:

    ~~~
       rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW pod create POD.yaml
    ~~~   

    This will cause the POD to be created, and the *deploy.sh* workflow script to be
    run on the Regional Controller's workflow engine. This in turn will login to remote node by ssh
    and install airship+ tungstenfabric demo on it

12. If you want to monitor ongoing progess of the installation, you can issue periodic calls
    to monitor the POD with:

    ~~~
          rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW pod show $PODID
    ~~~      

    where $PODID is the UUID of the POD. This will show all the messages logged by the
    workflow, as well as the current status of the workflow. The status will be WORKFLOW
    while the workflow is running, and wil change to ACTIVE if the workflow completes
    succesfully, or FAILED, if the workflow fails.

