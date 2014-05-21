## Not working yet

**In idot/deploy funktioniert, aber diese extrahierte Version noch nicht, ungeloest: wie referenziere ich
das bower.json? Muss das Skript in einem bestimmten Dir gestartet werden? Integrieren in npm? Oder grunt?**


The directory `scp` contains scripts which deploy the app from the localo workspace to a remote server. No repo involved. 

An example use is deploying AngularJS apps to the staging server, because usually Grunt would pack the application locally and prepare it for deployment, compressing, concating and minifying the JavaScript sources. Since these deployment tasks are already executed locally, we should take advantage of this preparation and copy the packed application directly to the server.

Depending on the type of application there might be several "ways to do it", thus several deploy scripts. The different types of deploy methods (scripts) are located in the several subdirectories:

* **default** ... standard way of copying plus configuring the app 

## default

This folder contains the standard way of deploying from stage to production.

Not too exciting features here, the following steps are performed:

1. create a timestamped directory on the server ("deployment directory")
2. upload all files to the deployment directory (via SCP)
3. ask user for an optional deployment comment
4. create version file (version.json) containing the deployment comment, if any and upload it. The information will be extracted from the `bower.json` file in the project root
5. overwrite config files by the prepared server-specific config files which are stored on the remote server
6. modify the symlink `app` in the application folder so that it points to the newly deployed version

### Install

To use the script:

1. copy the script `deploy.sh` to any folder you like, set chmod to 755.
2. add a `config.sh` file in the same directory (you can use the file `config.sh.sample` as a template). This should be populated with the actual configuration values.

**Note:** you may have to do a `fromdos` for the shell script and the sourced config script to run smoothly without warnings.
