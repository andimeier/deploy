The directory `stage-to-production` contains scripts which deploy the app from the staged version to the productive location. No repo involved, since we should be sure that exactly the staged and tested version is deployed.

Depending on the type of application there might be several "ways to do it", thus several deploy script. The different types of deploy methods (scripts) are located in the several subdirectories:

* **default** ... standard way of copying plus configuring the app 

## default

This folder contains the standard way of deploying from stage to production.

Not too exciting features here, the following steps are performed:

1. copy everyting from the stage folder into a timestamped directory
2. add target specific config file
3. modify the symlink `app` in the application folder so that it points to the newly deployed version
4. restart the app service

### Install

To use the script:

1. copy the script `deploy_stage_to_production.sh` to any folder you like, set chmod to 755.
2. add a `config.sh` file in the same directory (you can use the file `config.sh.sample` as a template). This should be populated with the actual configuration values.

**Note:** you may have to do a `fromdos` for the shell script to run smoothly without warnings.
